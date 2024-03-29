#include "dbc_parser.h"
#include <stdlib.h>
#include <stdio.h>
#include <stdbool.h>
#include <string.h>

#include <glib.h>
#include <iconv.h>

#include <candbc-model.h>
#include <candbc-reader.h>
#include "hashmap/hashmap.h"
#include "can_defs.h"
#include "log.h"

typedef struct
{
    int messages;
    int normal_messages;
    int multiplexed_messages;
    int multiplexed_message_combinations;
    int signals;
    int signals_bit_length;
} stats_t;

static bool dbc_synced = false;
static bool is_canfd = false;

int code_convert(const char *from_charset, const char *to_charset, char *inbuf, size_t inlen,
		char *outbuf, size_t outlen) {
	iconv_t cd;
	char **pin = &inbuf;
	char **pout = &outbuf;
 
	cd = iconv_open(to_charset, from_charset);
	if (cd == 0)
		return -1;
	memset(outbuf, 0, outlen);
	if (iconv(cd, pin, &inlen, pout, &outlen) == -1)
		return -1;
	iconv_close(cd);
    **pout = '\0';
 
	return 0;
}

int u2g(char *inbuf, size_t inlen, char *outbuf, size_t outlen) {
	return code_convert("utf-8", "gbk", inbuf, inlen, outbuf, outlen);
}
 
int g2u(char *inbuf, size_t inlen, char *outbuf, size_t outlen) {
	return code_convert("gbk", "utf-8", inbuf, inlen, outbuf, outlen);
}

bool has_dbc_synced() {
    return dbc_synced;
}

bool is_synced_dbc_canfd() {
    return is_canfd;
}

static void put_string(FlValue* result, const char* key, const char* value) {
    if(key != NULL && value != NULL) {
        fl_value_set_string_take(result, key, fl_value_new_string(value));
    }
}

static void put_g2u_string(FlValue* result, const char* key, char* value) {
    size_t len = strlen(value);
    size_t ulength = len * 2 * sizeof(char);
    char* ustr = (char*)malloc(ulength);
    memset(ustr, 0, ulength);
    g2u(value, len, ustr, ulength);
    put_string(result, key, ustr);
    free(ustr);
}

static char *convert_attribute_value_to_string(attribute_value_t *attribute_value)
{
    char *s_value;

    value_type_t value_type = attribute_value->value_type;
    value_union_t value = attribute_value->value;

    switch (value_type)
    {
    case vt_integer:
        s_value = g_strdup_printf("%ld", value.int_val);
        break;
    case vt_float:
        s_value = g_strdup_printf("%lg", value.double_val);
        break;
    case vt_string:
        s_value = g_strdup_printf("%s", value.string_val);
        break;
    case vt_enum:
        s_value = g_strdup_printf("%s", value.enum_val);
        break;
    case vt_hex:
        s_value = g_strdup_printf("%lu", value.hex_val);
        break;
    default:
        s_value = NULL;
    }

    return s_value;
}

static int extract_attribute_definitions(FlValue *result, attribute_definition_list_t *attribute_definition_list)
{
    if (attribute_definition_list == NULL)
        return 0;
    g_autoptr(FlValue) attr_map = fl_value_new_map();
    g_autoptr(FlValue) default_attr_map = fl_value_new_map();
    while (attribute_definition_list != NULL)
    {
        attribute_definition_t *attribute_definition = attribute_definition_list->attribute_definition;

        /** bustype 是否为CANFD **/
        if (attribute_definition->object_type == ot_network &&
            attribute_definition->value_type == vt_string) {
            string_t val = attribute_definition->default_value.string_val;
            if(val) {
                put_string(default_attr_map, attribute_definition->name, val);
            }
        }

        /* Extract ONLY enums of message objects */
        if (attribute_definition->object_type == ot_message &&
            attribute_definition->value_type == vt_enum)
        {
            /* Union */
            string_list_t *string_list = attribute_definition->range.enum_list;
            int i;

            g_autoptr(FlValue) attr = fl_value_new_map();

            i = 0;
            while (string_list != NULL)
            {
                char *s_value = g_strdup_printf("%d", i);
                put_string(attr, s_value, string_list->string);
                i++;
                string_list = string_list->next;
            }
            fl_value_set_string(attr_map, attribute_definition->name, attr);
        }
        attribute_definition_list = attribute_definition_list->next;
    }
    fl_value_set_string(result, "attribute_definitions", attr_map);
    fl_value_set_string(result, "default_attribute_definitions", default_attr_map);
    return 0;
}

static int extract_network_attributes(FlValue *result, network_t* network) {
    if(network == NULL || network->attribute_list == NULL) return 0;

    attribute_list_t *attribute_list = network->attribute_list;

    g_autoptr(FlValue) fv_attr = fl_value_new_map();

    while (attribute_list != NULL)
    {
        attribute_t *attribute = attribute_list->attribute;
        char *s_value = convert_attribute_value_to_string(attribute->value);
        if(s_value) {
            if(strcmp(s_value, "CAN FD") == 0) {
                is_canfd = true;
            }
            put_string(fv_attr, attribute->name, s_value);
            g_free(s_value);
        }
        attribute_list = attribute_list->next;
    }

    if(is_canfd) {
        fl_value_set_string_take(fv_attr, "canfd", fl_value_new_bool(true));
    } else {
        fl_value_set_string_take(fv_attr, "canfd", fl_value_new_bool(false));
    }

    fl_value_set_string(result, "network_attributes", fv_attr);
    return 0;
}

static int extract_message_attributes(FlValue *result, attribute_list_t *attribute_list)
{
    if (attribute_list == NULL)
        return 0;
    g_autoptr(FlValue) fv_attr = fl_value_new_map();

    while (attribute_list != NULL)
    {
        attribute_t *attribute = attribute_list->attribute;
        char *s_value = convert_attribute_value_to_string(attribute->value);
        if(s_value) {
            put_string(fv_attr, attribute->name, s_value);
            g_free(s_value);
        }

        attribute_list = attribute_list->next;
    }
    fl_value_set_string(result, "attributes", fv_attr);
    return 0;
}

static void extract_message_signals(FlValue *result, FlValue *signals, signal_list_t *signal_list,
                                    GHashTable *multiplexing_table, stats_t *stats) {
    if (signal_list == NULL)
        return;

    g_autoptr(FlValue) fv_signal_ids = fl_value_new_list();
    fl_value_set_string(result, "signal_ids", fv_signal_ids);

    while (signal_list != NULL) {
        g_autoptr(FlValue) fv_signal = fl_value_new_map();

        signal_t *signal = signal_list->signal;

        put_string(fv_signal, "name", signal->name);
        fl_value_set_string_take(fv_signal, "mid", fl_value_new_int(fl_value_get_int(fl_value_lookup_string(result, "id"))));
        fl_value_set_string_take(fv_signal, "start_bit", fl_value_new_int(signal->bit_start));
        fl_value_set_string_take(fv_signal, "length", fl_value_new_int(signal->bit_len));
        stats->signals_bit_length += signal->bit_len;
        fl_value_set_string_take(fv_signal, "little_endian", fl_value_new_int(signal->endianness));
        fl_value_set_string_take(fv_signal, "is_signed", fl_value_new_int(signal->signedness));

        if (signal->signal_val_type == svt_double) {
            put_string(fv_signal, "value_type", "double");
        } else if (signal->signal_val_type == svt_float) {
            put_string(fv_signal, "value_type", "float");
        } else {
            put_string(fv_signal, "value_type", "integer");
        }
        fl_value_set_string_take(fv_signal, "scaling", fl_value_new_float(signal->scale));
        fl_value_set_string_take(fv_signal, "offset", fl_value_new_float(signal->offset));
        fl_value_set_string_take(fv_signal, "minimum", fl_value_new_float(signal->min));
        fl_value_set_string_take(fv_signal, "maximum", fl_value_new_float(signal->max));
        if (signal->unit) {
            put_g2u_string(fv_signal, "unit", signal->unit);
        }

        if (signal->comment) {
            put_g2u_string(fv_signal, "comment", signal->comment);
        } else {
            put_string(fv_signal, "comment", "no comment for this signal");
        }

        if (signal->attribute_list) {
            extract_message_attributes(fv_signal, signal->attribute_list);
        }
        if (signal->val_map != NULL) {
            val_map_t *val_map = signal->val_map;
            g_autoptr(FlValue) fv_options = fl_value_new_map();

            while (val_map != NULL)
            {
                val_map_entry_t *val_map_entry = val_map->val_map_entry;
                gchar *key = g_strdup_printf("%lu", val_map_entry->index);

                put_g2u_string(fv_options, key, val_map_entry->value);

                val_map = val_map->next;
            }
            fl_value_set_string(fv_signal, "options", fv_options);
        }
        switch (signal->mux_type)
        {
        case m_multiplexor:
            fl_value_set_string_take(fv_signal, "multiplexor", fl_value_new_bool(true));
            break;
        case m_multiplexed:
            fl_value_set_string_take(fv_signal, "multiplexing", fl_value_new_int(signal->mux_value));
            g_hash_table_add(multiplexing_table, &(signal->mux_value));
            break;
        default:
            /* m_signal */
            break;
        }

        fl_value_set_string(signals, signal->name, fv_signal);

        // fl_value_append(signals, fv_signal);
        fl_value_append(fv_signal_ids, fl_value_lookup_string(fv_signal, "name"));
        stats->signals++;
        signal_list = signal_list->next;
    }
}

static void extract_messages(FlValue *result, message_list_t *message_list, stats_t *stats) {
        debug_info("start of extract_messages");
    // g_autoptr(FlValue) fv_message_list = fl_value_new_list();
    // g_autoptr(FlValue) fv_signals_list = fl_value_new_list();
    g_autoptr(FlValue) fv_message_list = fl_value_new_map();
    g_autoptr(FlValue) fv_signals_list = fl_value_new_map();
    fl_value_set_string(result, "messages", fv_message_list);
    fl_value_set_string(result, "signals", fv_signals_list);
    while (message_list != NULL) {
        g_autoptr(FlValue) fv_message = fl_value_new_map();
        // fl_value_append(fv_message_list, fv_message);

        int multiplexing_count;
        message_t *message = message_list->message;
        GHashTable *multiplexing_table = g_hash_table_new(g_int_hash, g_int_equal);
        fl_value_set_string_take(fv_message, "id", fl_value_new_int(message->id));
        put_string(fv_message, "name", message->name);
        put_string(fv_message, "sender", message->sender);
        fl_value_set_string_take(fv_message, "length", fl_value_new_int(message->len));
        extract_message_attributes(fv_message, message->attribute_list);
        extract_message_signals(fv_message, fv_signals_list, message->signal_list, multiplexing_table, stats);
        multiplexing_count = g_hash_table_size(multiplexing_table);
        if (multiplexing_count) {
            fl_value_set_string_take(fv_message, "has_multiplexor", fl_value_new_bool(true));

            /* Each mode provides a distinct message */
            stats->multiplexed_messages++;
            stats->multiplexed_message_combinations += multiplexing_count;
        } else {
            stats->normal_messages++;
        }
        // g_hash_table_destroy(multiplexing_table);

        char keystr[25];
        sprintf(keystr, "%lu", message->id);
        debug_info("kkkkkkkkkkkkey is %s", keystr);

        fl_value_set_string(fv_message_list, keystr, fv_message);

        stats->messages++;
        message_list = message_list->next;
        debug_info("extract_messages  message: %s", message->name);
    }
    debug_info("end of extract_messages");
}



int parse_dbc(const char *path, FlValue* result)
{

    char* _path = (char*)path;
    dbc_t *dbc = dbc_read_file(_path);

    put_string(result, "filename", dbc->filename);
    put_string(result, "version", dbc->version);
    extract_network_attributes(result, dbc->network);
    extract_attribute_definitions(result, dbc->attribute_definition_list);

    stats_t stats = {0};
    extract_messages(result, dbc->message_list, &stats);

    dbc_free(dbc);
    return 0;
}

typedef HASHMAP(uint32_t, struct message_meta) message_meta_repo;
typedef HASHMAP(char, struct signal_meta) signal_meta_repo;

static message_meta_repo m_repo;
static signal_meta_repo s_repo;


void clearup_message_meta_repo(message_meta_repo * repo) {
    struct message_meta * m;
    hashmap_foreach_data(m, repo) {
        list_destroy(m->signal_ids);
        free(m);
    }
    hashmap_cleanup(repo);
}

void clearup_signal_meta_repo(signal_meta_repo * repo) {
    struct signal_meta * m;
    hashmap_foreach_data(m, repo) {
        free(m);
    }
    hashmap_cleanup(repo);
}

size_t message_meta_size() {
    return hashmap_size(&m_repo);
}

struct message_meta * get_message_meta_by_id(uint32_t id) {
    return hashmap_get(&m_repo, &id);
}

struct signal_meta * get_signal_meta_by_id(const char * name) {
    return hashmap_get(&s_repo, name);
}

void
init_dbc_parser() {
    hashmap_init(&m_repo, hashmap_hash_integer, hash_integer_compare);
    hashmap_init(&s_repo, hashmap_hash_string, strcmp);
}

bool
dbc_parser_sync_meta_data(FlValue *args)
{
    debug_info("dbc_parser_sync_meta_data in ");
    if(hashmap_size(&m_repo) > 0) {
        debug_info("haha sssssssssssssssssssssssssssssssss   %ld, %ld", hashmap_size(&m_repo), hashmap_size(&s_repo));
        clearup_message_meta_repo(&m_repo);
        clearup_signal_meta_repo(&s_repo);
        is_canfd = false;
    }

    hashmap_init(&m_repo, hashmap_hash_integer, hash_integer_compare);
    hashmap_init(&s_repo, hashmap_hash_string, strcmp);
    if (fl_value_get_type(args) == FL_VALUE_TYPE_MAP)
    {
        FlValue *network_attributes = fl_value_lookup_string(args, "network_attributes");
        if(network_attributes) {

            FlValue *fl_is_canfd = fl_value_lookup_string(network_attributes, "canfd");
            is_canfd = fl_value_get_bool(fl_is_canfd);
        }

        FlValue *messages = fl_value_lookup_string(args, "messages");
        size_t message_metas_length = fl_value_get_length(messages);
        debug_info("dbc_parser_sync_meta_data message_metas_length : %ld", message_metas_length);

        for (size_t i = 0; i < message_metas_length; ++i)
        {
            struct message_meta * m_meta = (struct message_meta *)malloc(sizeof(struct message_meta));
            FlValue* m = fl_value_get_map_value(messages, i);
            FlValue *vid = fl_value_lookup_string(m, "id");
            FlValue *vname = fl_value_lookup_string(m, "name");
            FlValue *vlength = fl_value_lookup_string(m, "length");
            FlValue *signal_ids = fl_value_lookup_string(m, "signal_ids");
            strcpy(m_meta->name, fl_value_get_string(vname));
            m_meta->id = fl_value_get_int(vid);
            m_meta->length = fl_value_get_int(vlength);
            m_meta->signal_ids = list_new();

            size_t signal_ids_length = fl_value_get_length(signal_ids);

            for(size_t j = 0; j < signal_ids_length; ++j) {

                FlValue* sid = fl_value_get_list_value(signal_ids, j);
                char *ptr = (char*)malloc(256 * sizeof(*ptr));
                strcpy(ptr, fl_value_get_string(sid));
                list_node_t *sidNode = list_node_new((void*)ptr);
                list_rpush(m_meta->signal_ids, sidNode);
            }
            hashmap_put(&m_repo, &m_meta->id, m_meta);
        }

        FlValue *signals = fl_value_lookup_string(args, "signals");
        size_t signal_metas_length = fl_value_get_length(signals);

        for(size_t i = 0; i < signal_metas_length; ++i) {
            struct signal_meta * s_meta = (struct signal_meta *)malloc(sizeof(struct signal_meta));
            FlValue* s = fl_value_get_map_value(signals, i);
            s_meta->mid = fl_value_get_int(fl_value_lookup_string(s, "mid"));
            strcpy(s_meta->name, fl_value_get_string(fl_value_lookup_string(s, "name")));
            s_meta->start_bit = fl_value_get_int(fl_value_lookup_string(s, "start_bit"));
            s_meta->length = fl_value_get_int(fl_value_lookup_string(s, "length"));
            s_meta->scaling = fl_value_get_float(fl_value_lookup_string(s, "scaling"));
            s_meta->offset = fl_value_get_float(fl_value_lookup_string(s, "offset"));
            s_meta->minimum = fl_value_get_float(fl_value_lookup_string(s, "minimum"));
            s_meta->maximum = fl_value_get_float(fl_value_lookup_string(s, "maximum"));
            hashmap_put(&s_repo, s_meta->name, s_meta);
        }

        size_t size1 = hashmap_size(&m_repo);
        size_t size2 = hashmap_size(&s_repo);
        debug_info("sssssssssssssssssssssssssssssssss   %ld, %ld", size1, size2);

        dbc_synced = true;
        return true;
    }
    return false;
// name: IBS_SOC, start_bit: 7, length: 8, little_endian: 0, is_signed: 0,
// value_type: integer, scaling: 1.0, offset: 0.0, minimum: 0.0, maximum: 100.0,
// unit: %, comment: State of Charge, attributes: {GenSigStartValue: 255}, options: {255: invalid}},
    //      FlValue* messages = fl_value_lookup_string(args, "messages");
    //   }
    //     use_alpha_value = fl_value_lookup_string(args, kColorPanelShowAlpha);
//   gboolean use_alpha =
//       use_alpha_value != nullptr ? fl_value_get_bool(use_alpha_value) : FALSE;
//
//   FlView* view = fl_plugin_registrar_get_view(self->registrar);
//   if (view == nullptr) {
//     return FL_METHOD_RESPONSE(
        // fl_method_error_response_new(kNoScreenError, nullptr, nullptr));
}
