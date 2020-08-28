#include "can_operator.h"
#include "can_device.h"
#include "cstr.h"
#include <string.h>
#include <pthread.h>
#include <stdio.h>
#include <sys/time.h>
#include "log.h"
typedef enum
{
    AMMO_LOOP_CYCLE,
    AMMO_LOOP_LIMITED
} e_ammo_loop_type;

typedef enum
{
    AMMO_TRANSFORM_CONST,
    AMMO_TRANSFORM_SIN,
    AMMO_TRANSFORM_COS,
    AMMO_TRANSFORM_TAN,
    AMMO_TRANSFORM_COT
} e_ammo_transform_type;

typedef enum
{
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

struct signal_meta
{
    e_ammo_transform_type transform_type;
    unsigned int const_value;
    unsigned int last_trigon_angle;
    unsigned long last_timestamp;
    cstr_t *signal_name;
};

struct ammo_meta
{
    e_ammo_loop_type loop_type;
    e_ammo_order_type order_type;
    unsigned int sended_count;
    unsigned int sended_idx;
    unsigned int should_send_count = 1;

    list_t signal_meta_list;
};

// unsigned int (*build)(*PVCI_CAN_OBJ);
// void (*destroy)(PVCI_CAN_OBJ);

struct can_operator_sender
{
    list_t *ammo_meta_list;
    pthread_t thread;
    bool flag;
};

struct can_operator_receiver
{
    list_t *listeners;
    pthread_t thread;
    pthread_cond_t cond;
    pthread_mutex_t mutex;
    bool flag;
};

struct can_const_signal
{
    char *signal_name;
    unsigned int value;
};

static can_operator_sender sender;
static can_operator_receiver receiver;
static can_device *device;
static bool inited = false;

void *can_send_func(void *param)
{
    return 0;
}

void *can_receive_func(void *param)
{
    unsigned int cache_len = 100;
    VCI_CAN_OBJ can0_cache[cache_len];
    VCI_CAN_OBJ can1_cache[cache_len];
    unsigned int receive_can0_len = 0;
    unsigned int receive_can1_len = 0;

    struct timeval now;
    struct timespec outtime;
    pthread_mutex_lock(&receiver.mutex);
    while (receiver.flag)
    {
        memset(&can0_cache, 0, sizeof can0_cache);
        memset(&can1_cache, 0, sizeof can1_cache);
        if (device->ports[USB_CAN_PORT_0].started)
        {
            receive_can0_len = usb_can_receive(device, USB_CAN_PORT_0, can0_cache, cache_len, 20);
        }
        if (device->ports[USB_CAN_PORT_1].started)
        {
            receive_can1_len = usb_can_receive(device, USB_CAN_PORT_1, can1_cache, cache_len, 20);
        }
        gettimeofday(&now, NULL);
        outtime.tv_sec = now.tv_sec + 1;
        outtime.tv_nsec = now.tv_usec * 1000;
        pthread_cond_timedwait(&receiver.cond, &receiver.mutex, &outtime);
    }
    pthread_mutex_unlock(&receiver.mutex);
    return 0;
}

bool can_operator_init()
{
    if (inited)
        return true;
    unsigned int deviceCount = can_find();
    if(deviceCount == 0) return false;

    usb_can_new(&device, deviceCount);
    can_device * dev = device;
    for(int i = 0; i < deviceCount; ++i, ++dev) {
        usb_can_start(dev);
    }

    sender.ammo_meta_list = list_new();
    receiver.listeners = list_new();
    pthread_mutex_init(&receiver.mutex, NULL);
    pthread_cond_init(&receiver.cond, NULL);
    int err = pthread_create(&receiver.thread, NULL, &can_receive_func, NULL);
    if (err != 0)
    {
        printf("can_operator_init create receiver thread error: %d !", err);
    }
    return true;
}

void can_operator_destroy()
{
    receiver.flag = false;
    sender.flag = false;
    pthread_mutex_lock(&receiver.mutex);
    pthread_cond_signal(&receiver.cond);
    pthread_mutex_unlock(&receiver.mutex);
    usb_can_free(device);
    list_destroy(receiver.listeners);
    inited = false;
}

void can_operator_fire()
{
}

void can_operator_ceasefire()
{
}

void can_operator_add_listener(can_listener_t);
void can_operator_remove_listener(can_listener_t);
void can_operator_clear_listener();

void can_operator_add_const_signal(struct can_const_signal *);
void can_operator_add_signals_for_one_shot(list_t *);
