#ifndef REPLAY_OPERATOR_H
#define REPLAY_OPERATOR_H

#include <flutter_linux/flutter_linux.h>

#ifdef __cplusplus
extern "C" {
#endif

void replay_operator_set_file_path(const char* path);
const char* replay_operator_get_file_path();
void replay_operator_get_filted_signals(FlValue *filter, FlValue *result);

#ifdef __cplusplus
}
#endif //extern "C"

#endif //CAN_OPERATOR_H
