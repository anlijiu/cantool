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

struct usbcanii_device {
    const char *name;
    struct can_device device;
    pthread_t recv_thread;
    unsigned int idx;
    char serial[4];
    struct usbcanii_can_device_port ports[2];
};


#endif //__USBCANII_H__
