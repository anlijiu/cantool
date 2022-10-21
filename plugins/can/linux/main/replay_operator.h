#ifndef REPLAY_OPERATOR_H
#define REPLAY_OPERATOR_H

#include <flutter_linux/flutter_linux.h>
#include "list/list.h"
#include "hashmap/hashmap.h"

#ifdef __cplusplus
extern "C" {
#endif

struct message {
    uint32_t id;
    list_t * signal_ids;
};

typedef HASHMAP(uint32_t, struct message) filter_repo_map;

typedef void (*can_trace_cb)(FlValue*);

void replay_operator_set_file_path(const char* path);
const char* replay_operator_get_file_path();
void replay_operator_get_filted_signals(FlValue *filter, FlValue *result);
void replay_operator_parse_filted_signals(FlValue *filter, can_trace_cb cb);


#ifdef __cplusplus
}
#endif //extern "C"

#endif //CAN_OPERATOR_H
