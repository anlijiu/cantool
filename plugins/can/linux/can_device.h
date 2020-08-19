#ifndef CAN_DEVICE_H
#define CAN_DEVICE_H

#include <stdbool.h>
#include <controlcan.h>

#define USB_CAN_PORT_MAX 2
#define USB_CAN_PORT_0 0
#define USB_CAN_PORT_1 1

struct can_device_ops;

struct can_device_port {
    unsigned int idx;
    bool inited;
    bool started;
    VCI_INIT_CONFIG conf;
};

struct can_device {
    bool opened;
    unsigned int device_type;
    unsigned int device_idx = 0;
    unsigned int max_ports;
    struct can_device_port *ports;
    struct can_device_ops *ops;
};

struct can_device_ops {
	bool (*open)(struct can_device *);
	bool (*close)(struct can_device *);
	bool (*init)(struct can_device *, unsigned int);
	bool (*start)(struct can_device *, unsigned int);
	bool (*send)(struct can_device *, unsigned int, PVCI_CAN_OBJ, unsigned int);
	int (*recv)(struct can_device *, unsigned int, PVCI_CAN_OBJ, unsigned int, int);
};


#ifdef __cplusplus
extern "C" {
#endif


void usb_can_new(struct can_device **);
void usb_can_free(struct can_device *);

bool usb_can_start(struct can_device *);
bool usb_can_stop(struct can_device *);

bool usb_can_send(struct can_device *, unsigned int port, PVCI_CAN_OBJ pObj, unsigned int len);
unsigned int usb_can_receive(struct can_device *, unsigned int port, PVCI_CAN_OBJ pObj, unsigned int len, int wait_time);



#ifdef __cplusplus
}
#endif



#endif //CAN_DEVICE_H
