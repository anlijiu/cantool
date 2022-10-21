#ifndef CAN_OPERATOR_H
#define CAN_OPERATOR_H


#include <stdbool.h>
#include <stdint.h>
#include "device.h"
#include "can_defs.h"

#ifdef __cplusplus
extern "C" {
#endif

bool can_operator_init();
void can_operator_destroy();

void can_operator_fire();
void can_operator_ceasefire();

void can_operator_add_listener(on_recv_fun_t);
void can_operator_remove_listener(on_recv_fun_t);
void can_operator_clear_listener();

void can_operator_add_canfd_listener(on_canfd_recv_fun_t);
void can_operator_remove_canfd_listener(on_canfd_recv_fun_t);
void can_operator_clear_canfd_listener();

void can_operator_add_const_signal_builder(const char* name, double value);
void can_operator_add_message(uint32_t mid);
void can_operator_remove_message(uint32_t mid);


#ifdef __cplusplus
}
#endif

#endif //CAN_OPERATOR_H
