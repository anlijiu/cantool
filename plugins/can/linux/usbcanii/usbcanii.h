#ifndef __USBCANII_H__
#define __USBCANII_H__

#include "module.h"
#include "controlcan.h"
#include <stdbool.h>
#include <pthread.h>

#define USB_CAN_DEVICE_TYPE 4
#define USB_CAN_PORT_COUNT 2
#define USBCANII_NAME "usbcanii"

struct usbcanii_can_device_port{
    bool inited;
    VCI_INIT_CONFIG conf;
};

struct can_operator_sender
{
    // message_assembler_map m_assembler_map;
    // signal_assembler_map s_assembler_map;
    pthread_t thread;
    pthread_cond_t cond;
    pthread_mutex_t mutex;
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

struct usbcanii_device {
    const char *name;
    struct can_device device;
    unsigned int idx;
    char serial[4];
    struct usbcanii_can_device_port ports[2];
    pthread_t recv_thread;
};


#endif //__USBCANII_H__
