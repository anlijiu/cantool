#include "can_device.h"


bool usb_can_ops_open(struct can_device * device)
{
    bool result = (VCI_OpenDevice(device->device_type, device->device_idx, 0)==1);
    device->opened = result;
    return result;
}

bool usb_can_ops_close(struct can_device * device)
{
    bool result = (VCI_CloseDevice(device->device_type, device->device_idx)==1);
    device->opened = !result;
    return result;
}

bool usb_can_ops_init(struct can_device * device, unsigned int port_idx) {
    if(USB_CAN_PORT_0 == port_idx || USB_CAN_PORT_1 == port_idx) {
        bool result = (VCI_InitCAN(device->device_type, device->device_idx, device->ports[port_idx]->idx, device->ports[port_idx]->conf)==1);
        port->inited = result;
        return result;
    }

    return false;
}

bool usb_can_ops_start(struct can_device * device, unsigned int port_idx) {
    if(USB_CAN_PORT_0 == port_idx || USB_CAN_PORT_1 == port_idx) {
        bool result = (VCI_StartCAN(device->device_type, device->device_idx, device->ports[port_idx]->idx, device->ports[port_idx]->conf)==1);
        port->started = result;
        return result;
    }

    return false;
}

bool usb_can_ops_send(struct can_device * device, unsigned int port_idx, PVCI_CAN_OBJ pObj, unsigned int len) {
    if(USB_CAN_PORT_0 == port_idx || USB_CAN_PORT_1 == port_idx) {
        bool result = (VCI_Transmit(device->device_type, device->device_idx, device->ports[port_idx]->idx, pObj, len)==1);
        return result;
    }

    return false;
}

int usb_can_ops_recv(struct can_device * device, unsigned int port_idx, PVCI_CAN_OBJ pObj, unsigned int len, int wait) {
    if(USB_CAN_PORT_0 == port_idx || USB_CAN_PORT_1 == port_idx) {
        int receive_len = VCI_Receive(device->device_type, device->device_idx, device->ports[port_idx]->idx, pObj, len, wait);
        return receive_len;
    }

    return 0;
}


static struct can_device_ops usb_can_device_ops = {
	.open = usb_can_ops_open,
	.close = usb_can_ops_close,
	.init = usb_can_ops_init,
	.start = usb_can_ops_start,
	.send = usb_can_ops_send,
	.recv = usb_can_ops_recv,
}

void usb_can_vci_init(PVCI_INIT_CONFIG pconf) {
    pconf->AccCode = 0x80000008;
    pconf->AccMask = 0xFFFFFFFF;
    pconf->Filter = 1;//receive all frames
    pconf->Timing0 = 0x00;
    pconf->Timing1 = 0x1C;//baudrate 500kbps
    pconf->Mode = 0;//normal mode
}

void usb_can_port_init(struct can_device_port * port, unsigned int idx) {
    memset(port, sizeof(*port), 0);
    port->idx = idx;
    port->inited = false;
    port->started = false;
    usb_can_vci_init(&port->conf);
}

void usb_can_new(struct can_device ** dev) {
    *dev = (struct can_device *)malloc(sizeof(struct can_device)); 
    struct can_device * device = *dev;
    memset(device, sizeof(*device), 0);
    device->max_ports = USB_CAN_PORT_MAX;
    device->device_type = 4;
    device->ports = malloc(sizeof(struct can_device_port) * USB_CAN_PORT_MAX);
    struct can_device_port * port = device->ports;
    for(unsigned int i = 0; i < USB_CAN_PORT_MAX; ++i, ++port) {
        usb_can_port_init(port, i)
    }
    device->ops = &usb_can_device_ops;
}

void usb_can_free(struct can_device * device) {
    struct can_device_port * port = device->ports;
    for(unsigned int i = 0; i < USB_CAN_PORT_MAX; ++i, ++port) {
        free(port);
    }
    free(device);
}

bool usb_can_start(struct can_device * device) {
    bool status = device->ops->open(device);
    if(status) {
        status = device->ops->init(device, USB_CAN_PORT_0);
        status = device->ops->init(device, USB_CAN_PORT_1);
    }
    if(status) {
        status = device->ops->start(device, USB_CAN_PORT_0);
        status = device->ops->start(device, USB_CAN_PORT_1);
    }
    return status;
}

bool usb_can_stop(struct can_device * device) {
    bool status = device->ops->close(device);
    return status;
}

bool usb_can_send(struct can_device * device, unsigned int port, PVCI_CAN_OBJ pObj, unsigned int len) {
    return device->ops->send(device, port_idx, pObj, len);
}

unsigned int usb_can_receive(struct can_device * device, unsigned int port, PVCI_CAN_OBJ pObj, unsigned int len, int wait_time) {
    return device->ops->recv(device, port_idx, pObj, len, wait_time);
}
