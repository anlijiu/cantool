#ifndef CAN_DEVICE_H
#define CAN_DEVICE_H

#include <stdbool.h>

#define USB_CAN_PORT_0 0
#define USB_CAN_PORT_1 1

struct can_device_ops, can_device_port_ops ;
struct can_device_port {
    unsigned int idx;
    bool inited;
    bool started;
    struct can_device_port_ops *ops;
    PVCI_INIT_CONFIG conf;
};
struct can_device {
    bool opened;
    unsigned int device_type;
    unsigned int device_idx = 0;//当前只支持一个设备
    struct can_device_port ports[2];
    struct can_device_ops *ops;
};

struct can_device_ops {
	bool (*open)();
	bool (*close)();
	bool (*init)(unsigned int port);
	bool (*start)(unsigned int port);
	bool (*send)(unsigned int port, PVCI_CAN_OBJ pObj, unsigned int len);
	bool (*receive)(unsigned int port, PVCI_CAN_OBJ pObj, unsigned int len, int wait);
}

struct can_device_port_ops {
	bool (*open)();
	bool (*close)();
	bool (*init)();
	bool (*start)();
	bool (*send)(PVCI_CAN_OBJ pObj, unsigned int len);
	bool (*receive)(PVCI_CAN_OBJ pObj, unsigned int len, int wait);

	// struct can_device_ops *__super;
};

#ifdef __cplusplus 
extern "C" { 
#endif


struct can_device * usb_can_device_init();



#ifdef __cplusplus
}
#endif



#endif //CAN_DEVICE_H
