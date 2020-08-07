
typedef bool (*can_listener_t)(PVCI_CAN_OBJ pObj, unsigned int len);

void can_operator_init();

void can_operator_fire();
void can_operator_ceasefire();

void can_operator_add_listener(can_listener_t);
void can_operator_remove_listener(can_listener_t);
void can_operator_clear_listener();

void can_operator_add_const_signal(struct can_const_signal *);
void can_operator_add_signals_for_one_shot(list_t *);
// void add_sin_signal(char * signal_name);
// void add_cos_signal(char * signal_name);
// void add_tan_signal(char * signal_name);
// void add_cot_signal(char * signal_name);
