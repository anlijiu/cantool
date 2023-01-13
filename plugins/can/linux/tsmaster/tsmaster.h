#ifndef __USBCANII_H__
#define __USBCANII_H__

#include "module.h"
#include "queue/queue.h"
#include "TSCANDef.h"
#include <stdbool.h>

#define USB_CAN_DEVICE_TYPE 4
#define USB_CAN_PORT_COUNT 2
#define TSMASTER_NAME "tsmaster"


struct tsmaster_device {
    struct can_device device;
    uint64_t ADeviceHandle;
    const char *name;
    char* AFManufacturer;
    char* AFProduct;
    char* AFSerial;
    pthread_t recv_thread;
    queue_t *q;
};


#endif //__USBCANII_H__
