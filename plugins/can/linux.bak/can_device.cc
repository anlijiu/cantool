#include "can_device.h"

static VCI_INIT_CONFIG vci_conf0 = {
  .AccCode = 0x80000008;
  .AccMask = 0xFFFFFFFF;
  .Filter = 1;//receive all frames
  .Timing0 = 0x00;
  .Timing1 = 0x1C;//baudrate 500kbps
  .Mode = 0;//normal mode
};

static VCI_INIT_CONFIG vci_conf1 = {
  .AccCode = 0x80000008;
  .AccMask = 0xFFFFFFFF;
  .Filter = 1;//receive all frames
  .Timing0 = 0x00;
  .Timing1 = 0x1C;//baudrate 500kbps
  .Mode = 0;//normal mode
};

static struct can_device_port usb_can_0 = {
    .port = 0,
    .opened = false,
    .conf = &vci_conf0,
}

static struct can_device_port usb_can_1 = {
    .port = 0,
    .opened = false,
    .conf = &vci_conf1,
}

static struct can_device usb_can_device = {
    .device_type = 4,
    .ports = { &usb_can_0, &usb_can_1 }
}

static bool can_ops_open(struct can_device *device)
{
    bool result = (VCI_OpenDevice(device->device_type, device->device_idx, 0)==1);
    device->opened = result;
    return result;
}

static bool can_ops_close(struct can_device *device)
{
    bool result = (VCI_CloseDevice(device->device_type, device->device_idx)==1);
    device->opened = !result;
    return result;
}

static bool can_ops_init(struct can_device *device, struct can_device_port *port)
{
    bool result = (VCI_InitCAN(device->device_type, device->device_idx, port->idx, port->conf)==1);
    port->inited = result;
    return result;
}

static void can_ops_start(struct can_device *device, struct can_device_port *port)
{
    bool result = (VCI_StartCAN(device->device_type, device->device_idx, port->idx, port->conf)==1);
    port->started = result;
    return result;
}

static bool can_ops_send(struct can_device *device, struct can_device_port *port, PVCI_CAN_OBJ pObj, unsigned int len)
{
    bool result = (VCI_Transmit(device->device_type, device->device_idx, port->idx, pObj, len)==1);
    return result;
}

static unsigned int can_ops_recv(struct can_device *device, struct can_device_port *port, PVCI_CAN_OBJ pObj, unsigned int len, int wait)
{
    int receive_len = VCI_Receive(device->device_type, device->device_idx, port->idx, pObj, len, wait);
    return receive_len;
}


bool usb_can_ops_open(void)
{
    return can_ops_open(&usb_can_device); // => 25             
}
bool usb_can_ops_close(void)
{
    return can_ops_close(&usb_can_device); // => 25             
}
bool usb_can_ops_init(unsigned int port) {
    if(USB_CAN_PORT_0 == port || USB_CAN_PORT_1 == port) {
        return can_ops_init(&usb_can_device, usb_can_device.ports[port]);
    }

    return false;
}

bool usb_can_ops_start(unsigned int port) {
    if(USB_CAN_PORT_0 == port || USB_CAN_PORT_1 == port) {
        return can_ops_start(&usb_can_device, usb_can_device.ports[port]);
    }

    return false;
}

bool usb_can_ops_send(unsigned int port, PVCI_CAN_OBJ pObj, unsigned int len) {
    if(USB_CAN_PORT_0 == port || USB_CAN_PORT_1 == port) {
        return can_ops_send(&usb_can_device, usb_can_device.ports[port], pObj, len);
    }

    return false;
}

bool usb_can_ops_recv(unsigned int port, PVCI_CAN_OBJ pObj, unsigned int len, int wait) {
    if(USB_CAN_PORT_0 == port || USB_CAN_PORT_1 == port) {
        return can_ops_recv(&usb_can_device, usb_can_device.ports[port], pObj, len, int wait);
    }

    return false;
}


bool usb_can_0_ops_init(void) {
    return can_ops_init(&usb_can_device, &usb_can_0);
}
bool usb_can_1_ops_init(void) {
    return can_ops_init(&usb_can_device, &usb_can_1);
}
bool usb_can_0_ops_start(void) {
    return can_ops_start(&usb_can_device, &usb_can_0);
}
bool usb_can_1_ops_start(void) {
    return can_ops_start(&usb_can_device, &usb_can_1);
}
bool usb_can_0_ops_send(PVCI_CAN_OBJ pObj, unsigned int len) {
    return can_ops_send(&usb_can_device, &usb_can_0, pObj, len);
}
bool usb_can_1_ops_send(PVCI_CAN_OBJ pObj, unsigned int len) {
    return can_ops_send(&usb_can_device, &usb_can_1, pObj, len);
}
bool usb_can_0_ops_recv(PVCI_CAN_OBJ pObj, unsigned int len, int wait) {
    return can_ops_recv(&usb_can_device, &usb_can_0, pObj, len, int wait);
}
bool usb_can_1_ops_recv(PVCI_CAN_OBJ pObj, unsigned int len, int wait) {
    return can_ops_recv(&usb_can_device, &usb_can_1, pObj, len, wait);
}

static struct can_device_port_ops usb_can_port_0_ops = {
	.open = usb_can_ops_open,
	.close = usb_can_ops_close,
	.init = usb_can_0_ops_init,
	.start = usb_can_0_ops_start,
	.send = usb_can_0_ops_send,
	.recv = usb_can_0_ops_recv,
};
static struct can_device_port_ops usb_can_port_1_ops = {
	.open = usb_can_ops_open,
	.close = usb_can_ops_close,
	.init = usb_can_1_ops_init,
	.start = usb_can_1_ops_start,
	.send = usb_can_1_ops_send,
	.recv = usb_can_1_ops_recv,
};

static struct can_device_ops can_device_ops = {
	.open = usb_can_ops_open,
	.close = usb_can_ops_close,
	.init = usb_can_ops_init,
	.start = usb_can_ops_start,
	.send = usb_can_ops_send,
	.recv = usb_can_ops_recv,
}

struct can_device * usb_can_device_init()
{
    usb_can_device.ops = &can_device_ops;
    usb_can_0.ops = &usb_can_port_0_ops;
    usb_can_1.ops = &usb_can_port_1_ops;
    return &usb_can_device;
}
