#ifndef __USBCANII_H__
#define __USBCANII_H__

#include "module.h"
#include "TSCANDef.h"
#include <stdbool.h>

#define USB_CAN_DEVICE_TYPE 4
#define USB_CAN_PORT_COUNT 2
#define TSMASTER_NAME "tsmaster"


struct tsmaster_device {
    const char *name;
    struct can_device device;
    char* AFManufacturer;
    char* AFProduct;
    char* AFSerial;
    uint64_t ADeviceHandle;
};


#endif //__USBCANII_H__
