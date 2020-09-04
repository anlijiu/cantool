
#ifndef CAN_OPERATOR_H
#define CAN_OPERATOR_H

#include <flutter_linux/flutter_linux.h>
#include "controlcan.h"
#include "list/list.h"
#include "can_defs.h"

#ifdef __cplusplus
extern "C" {
#endif


typedef bool (*can_listener_t)(FlValue*);

bool can_operator_init();
void can_operator_destroy();

void can_operator_fire();
void can_operator_ceasefire();

void can_operator_add_listener(can_listener_t);
void can_operator_remove_listener(can_listener_t);
void can_operator_clear_listener();

void can_operator_add_const_signal_builder(const char* name, double value);
void can_operator_add_message(uint32_t mid);
void can_operator_remove_message(uint32_t mid);
// void add_sin_signal(char * signal_name);
// void add_cos_signal(char * signal_name);
// void add_tan_signal(char * signal_name);
// void add_cot_signal(char * signal_name);

#ifdef __cplusplus
}
#endif


#endif //CAN_OPERATOR_H