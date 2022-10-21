#ifndef DBC_PARSER
#define DBC_PARSER

#include <flutter_linux/flutter_linux.h>
#include <gtk/gtk.h>
#include "list/list.h"

#ifdef __cplusplus
extern "C" {
#endif



int parse_dbc(const char *path, FlValue* result);
bool dbc_parser_sync_meta_data(FlValue* result);
struct message_meta * get_message_meta_by_id(uint32_t id);
struct signal_meta * get_signal_meta_by_id(const char * name);
size_t message_meta_size();
bool has_dbc_synced();
bool is_synced_dbc_canfd();

#ifdef __cplusplus
}
#endif


#endif //DBC_PARSER
