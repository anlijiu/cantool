#include <flutter_linux/flutter_linux.h>
#include <pthread.h>
#include <string.h>
#include <stdbool.h>
#include "replay_operator.h"
#include "log.h"
#include "asc_reader.h"
#include "blfreader.h"


static char* g_path;

struct replay_operator
{
    pthread_t thread;
    pthread_mutex_t mutex;
    can_trace_cb cb;
    filter_repo_map filter_repo;

    bool running;
};

static struct replay_operator op = { .mutex = PTHREAD_MUTEX_INITIALIZER };

static const char *get_filename_ext(const char *filename) {
    const char *dot = strrchr(filename, '.');
    if(!dot || dot == filename) return "";
    return dot + 1;
}

void replay_operator_set_file_path(const char* path) {
    debug_info("%s in. path: %s\n", __func__ , path);
    if(g_path != NULL) {
        g_path = (char*)realloc(g_path, strlen(path));
    } else {
        g_path = (char*)malloc(strlen(path));
    }

    if(g_path == NULL) {
        debug_info("alloc memory failed in %s.\n", __FUNCTION__);
    }
    
    strcpy(g_path, path);
}

const char* replay_operator_get_file_path() {
    return g_path;
}

void replay_operator_get_filted_signals(FlValue *filter, FlValue *result)
{
    return;
}

void _parse_proxy_cb(FlValue* result) {
    size_t s_length = fl_value_get_length(result);
    debug_info("%s in. result length: %ld\n", __FUNCTION__, s_length);
    can_trace_cb cb = op.cb;
    cb(result);
    // FlValue* isEnd = fl_value_lookup_string(result, "isEnd");
    // if(isEnd != NULL && fl_value_get_bool(isEnd)) {
    // }
}

void _init_filter_repo(FlValue *filter) {
    debug_info("%s in.\n", __FUNCTION__);
    hashmap_init(&op.filter_repo, hashmap_hash_integer, hash_integer_compare);

    size_t m_length = fl_value_get_length(filter);
    debug_info("%s in.   filter m_length: %ld\n", __FUNCTION__, m_length);
    for (size_t i = 0; i < m_length; ++i) {
        FlValue* mv = fl_value_get_list_value(filter, i);
        struct message* msg = (struct message*)malloc(sizeof(struct message));
        msg->signal_ids = list_new();
        msg->signal_ids->free = free;
        msg->id = fl_value_get_int(fl_value_lookup_string(mv, "id"));
        FlValue* ss = fl_value_lookup_string(mv, "signals");
        size_t s_length = fl_value_get_length(ss);
        debug_info("%s in.   s_length: %ld\n", __FUNCTION__, s_length);
        for (size_t j = 0; j < s_length; ++j) {
            FlValue* skey = fl_value_get_map_key(ss, j);
            const char* sid = fl_value_get_string(skey);
            char *ptr = (char*)malloc(256 * sizeof(*ptr));
            strcpy(ptr, sid);
            printf("%s sid is %s\n", __FUNCTION__, sid);
            list_node_t *s_node = list_node_new((void*)ptr);
            list_rpush(msg->signal_ids, s_node);
        }
        debug_info("%s filter id: %u\n", __FUNCTION__, msg->id);
        hashmap_put(&op.filter_repo, &msg->id, msg);
    }
    // hashmap_foreach(key, value, &op.filter_repo) {
    //     printf("filter id: %d\n", *key);
    // }
}

void _destroy_filter_repo() {
    debug_info("%s in.\n", __FUNCTION__);
    struct message * mptr;
    hashmap_foreach_data(mptr, &op.filter_repo) {
        list_destroy(mptr->signal_ids);
        free(mptr);
    }
    hashmap_cleanup(&op.filter_repo);
}

static void* _parse(void *param) {

    debug_info("%s in.\n", __FUNCTION__);
    pthread_mutex_lock(&op.mutex);

    bool ok = false;

    if(strcmp("asc", get_filename_ext(g_path)) == 0) {
        debug_info("replay_operator  parse asc in %s.\n", __FUNCTION__);
        ok = parse_asc(g_path, &op.filter_repo, _parse_proxy_cb);
    } else if(strcmp("blf", get_filename_ext(g_path)) == 0) {
        debug_info("replay_operator  parse blf in %s.\n", __FUNCTION__);
        ok = parse_blf(g_path, &op.filter_repo, _parse_proxy_cb);
    } else {
    }

    debug_info("%s parse result:%d.\n", __FUNCTION__, ok);
    _destroy_filter_repo();
    op.running = false;
    pthread_mutex_unlock(&op.mutex);
    return 0;
}

void replay_operator_parse_filted_signals(FlValue *filter, can_trace_cb cb) {
    debug_info("%s in.\n", __FUNCTION__);
    if(g_path == NULL || op.running) return;

    op.running = true;
    op.cb = cb;
    _init_filter_repo(filter);

    int err = pthread_create(&op.thread, NULL, &_parse, NULL);
    if (err != 0)
    {
        printf("can_operator_init create sender thread error: %d !", err);
    }
    pthread_detach(op.thread);
}

// static void _parse(FlValue *filter, can_trace_cb cb) {
// 
//     bool ok = false;
// 
//     if(strcmp("asc", get_filename_ext(g_path)) == 0) {
//         ok = parse_asc(g_path, filter, cb);
//     } else if(strcmp("blf", get_filename_ext(g_path)) == 0) {
//         debug_info("replay_operator  parse blf in %s.\n", __FUNCTION__);
//         ok = parse_blf(g_path, filter, cb);
//     } else {
//     }
// }
