#include "can_operator.h"

typedef enum {
    AMMO_LOOP_CYCLE,
    AMMO_LOOP_LIMITED
} e_ammo_loop_type;

typedef enum {
    AMMO_TRANSFORM_CONST,
    AMMO_TRANSFORM_SIN,
    AMMO_TRANSFORM_COS,
    AMMO_TRANSFORM_TAN,
    AMMO_TRANSFORM_COT
} e_ammo_transform_type;

typedef enum {
    AMMO_ORDER_SEQUENCE,
    AMMO_ORDER_TOGETHER
} e_ammo_order_type;

/**
 *
 *  无限循环const发送
 *  无限循环sin发送
 *  无限循环sin发送
 *  有限次数发送(发一次)
 *  顺序发送一组(循环/发一次)
 */

struct signal_meta {
    e_ammo_transform_type transform_type;
    unsigned int const_value;
    unsigned int last_trigon_angle;
    unsigned long last_timestamp;
    cstr_t *signal_name;
}

struct ammo_meta {
    e_ammo_loop_type loop_type;
    e_ammo_order_type order_type;
    unsigned int sended_count;
    unsigned int sended_idx;
    unsigned int should_send_count = 1;

    list_t signal_meta_list;
}

    // unsigned int (*build)(*PVCI_CAN_OBJ);
    // void (*destroy)(PVCI_CAN_OBJ);


struct can_operator_sender {
    list_t * ammo_meta_list;
    pthread_t thread;
    bool flag;
}

struct can_operator_receiver {
    list_t * listeners;
    pthread_t thread;
    pthread_cond_t cond;
    pthread_mutex_t mutex;
    bool flag;
};

struct can_const_signal {
    char * signal_name;
    unsigned int value;
};


static can_operator_sender sender;
static can_operator_receiver receiver;
static can_device * device;


void *can_send_func(void *param) {
}
void *can_receive_func(void *param) {
    VCI_CAN_OBJ can0_cache[100];
    VCI_CAN_OBJ can1_cache[100];
    unsigned int cache_len = 100;
    unsigned int receive_can0_len = 0;
    unsigned int receive_can1_len = 0;
    while(receiver.flag) {
        memset(&can0_cache, 0, sizeof can0_cache);
        memset(&can1_cache, 0, sizeof can1_cache);
        if(device->ports[USB_CAN_PORT_0].started) {
            receive_can0_len = usb_can_receive(device, USB_CAN_PORT_0, can0_cache, 100, 20);
        }
        if(device->ports[USB_CAN_PORT_1].started) {
            receive_can1_len = usb_can_receive(device, USB_CAN_PORT_1, can1_cache, 100, 20);
        }
      for(int i = 0; i < receive_len; ++i) {
        if(can_obj[i].ID == 0) continue;

        Message message {
                (uint32_t)can_obj[i].ID,
                (uint8_t)can_obj[i].DataLen,
        };
        std::memcpy(message.raw, can_obj[i].Data, 8);
        messages.push_back(message);
      }
      // receive_mtx.lock();
      processReceiveData(messages);
      // receive_mtx.unlock();

//      OnReceiveMessage(can_obj);
      //ROS_INFO("received:%u",can_obj.ID);
      // canalystii_node_msg::can msg = CANalystii_node::can_obj2msg(can_obj);
      // can_node.can_msg_pub_.publish(msg);
    }
    std::this_thread::sleep_for (std::chrono::milliseconds(50));
    //ros::spinOnce();
  }
}

void can_operator_init() {
    device = usb_can_new();
    usb_can_start(device);
    sender.ammo_meta_list = list_new();
    receiver.listeners = list_new();
    int err = pthread_create(&receiver.thread, NULL, &can_receive_func, NULL);
    if(err != 0) {
        printf("can_operator_init create receiver thread error: %d !", err);
    }
}

void can_operator_destroy() {
    usb_can_free(device);
    list_destroy(receiver.listeners);
}

void can_operator_fire() {
}

void can_operator_ceasefire() {
}

void can_operator_add_listener(can_listener_t);
void can_operator_remove_listener(can_listener_t);
void can_operator_clear_listener();

void can_operator_add_const_signal(struct can_const_signal *);
void can_operator_add_signals_for_one_shot(list_t *);
