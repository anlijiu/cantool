#ifndef INCLUDE_ASCREAD_H
#define INCLUDE_ASCREAD_H

#include <stdio.h>
#include <candbc-types.h>
#include <time.h>
#include <flutter_linux/flutter_linux.h>
#include <stdbool.h>
#include <replay_operator.h>

#ifdef __cplusplus
extern "C" {
#endif

// bool parse_asc(const char *path, FlValue* filter, FlValue* result);
bool parse_asc(const char *path, filter_repo_map* filter, can_trace_cb cb);

#ifdef __cplusplus
}
#endif

#endif
