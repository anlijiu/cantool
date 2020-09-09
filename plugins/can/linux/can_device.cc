#include "can_device.h"
#include "log.h"
#include <string.h>
#include <stdlib.h>
#include <stdio.h>
#include "libusb.h"
#include "log.h"

bool usb_can_ops_open(struct can_device * device)
{
    int result = VCI_OpenDevice(device->device_type, device->device_idx, 0);
    debug_info("usb_can_ops_open   result is %d\n", result);
    device->opened = result == 1;
    return device->opened;
}

bool usb_can_ops_close(struct can_device * device)
{
    int result = VCI_CloseDevice(device->device_type, device->device_idx);
    debug_info("usb_can_ops_close   result is %d\n", result);
    device->opened = result == 1;
    return device->opened;
}

bool usb_can_ops_init(struct can_device * device, unsigned int port_idx) {
    if(USB_CAN_PORT_0 == port_idx || USB_CAN_PORT_1 == port_idx) {
        bool result = (VCI_InitCAN(device->device_type, device->device_idx, device->ports[port_idx].idx, &device->ports[port_idx].conf)==1);
        device->ports[port_idx].inited = result;
        return result;
    }

    return false;
}

bool usb_can_ops_start(struct can_device * device, unsigned int port_idx) {
    if(USB_CAN_PORT_0 == port_idx || USB_CAN_PORT_1 == port_idx) {
        bool result = (VCI_StartCAN(device->device_type, device->device_idx, device->ports[port_idx].idx)==1);
        device->ports[port_idx].started = result;
        return result;
    }

    return false;
}

bool usb_can_ops_send(struct can_device * device, unsigned int port_idx, PVCI_CAN_OBJ pObj, unsigned int len) {
    if(USB_CAN_PORT_0 == port_idx || USB_CAN_PORT_1 == port_idx) {
        int send_len = VCI_Transmit(device->device_type, device->device_idx, device->ports[port_idx].idx, pObj, len);
        debug_info("usb_can_ops_send  deviceType:%d, deviceIdx: %d, port:%d, len: %d, send_len:%d",
                   device->device_type, device->device_idx, device->ports[port_idx].idx, len, send_len);
        return send_len == len;
    }

    return false;
}

int usb_can_ops_recv(struct can_device * device, unsigned int port_idx, PVCI_CAN_OBJ pObj, unsigned int len, int wait) {
    if(USB_CAN_PORT_0 == port_idx || USB_CAN_PORT_1 == port_idx) {
        int receive_len = VCI_Receive(device->device_type, device->device_idx, device->ports[port_idx].idx, pObj, len, wait);
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
};

void usb_can_vci_init(PVCI_INIT_CONFIG pconf) {
    pconf->AccCode = 0x80000008;
    pconf->AccMask = 0xFFFFFFFF;
    pconf->Filter = 1;//receive all frames
    pconf->Timing0 = 0x00;
    pconf->Timing1 = 0x1C;//baudrate 500kbps
    pconf->Mode = 0;//normal mode
}

void usb_can_port_init(struct can_device_port * port, unsigned int idx) {
    memset(port, 0, sizeof(*port));
    port->idx = idx;
    port->inited = false;
    port->started = false;
    usb_can_vci_init(&port->conf);
}


static VCI_BOARD_INFO1 boardInfo;
static unsigned int deviceCount;
unsigned int can_find() {
    deviceCount = VCI_FindUsbDevice(&boardInfo);
    debug_info("VCI_FindUsbDevice  result: %d, hw_Version:%d, fw_Version:%d, dr_Version:%d, in_Version:%d,irq_Num:%d, canNum is %d, Reserved:%d, str_Serial_Num:%s, str_hw_Type:%s", deviceCount,boardInfo.hw_Version, boardInfo.fw_Version, boardInfo.dr_Version, boardInfo.in_Version, boardInfo.irq_Num, boardInfo.can_Num, boardInfo.Reserved, boardInfo.str_Serial_Num, boardInfo.str_hw_Type);
    for(int i = 0; i < deviceCount; ++i) {
        debug_info("VCI_FindUsbDevice str_Usb_Serial[%d]: %s ", i, boardInfo.str_Usb_Serial[i]);
    }
    return deviceCount;
}

void usb_can_new(struct can_device ** dev, unsigned int count) {
    *dev = (struct can_device *)malloc(sizeof(struct can_device) * count);
    struct can_device * device = *dev;
    memset(device, 0, sizeof(*device) * count);
    for (int i = 0; i < count; ++i, ++device)
    {
        device->max_ports = USB_CAN_PORT_MAX;
        device->device_type = 4;
        device->ports = (struct can_device_port *)malloc(sizeof(struct can_device_port) * USB_CAN_PORT_MAX);
        struct can_device_port *port = device->ports;
        for (unsigned int j = 0; j < USB_CAN_PORT_MAX; ++j, ++port)
        {
            usb_can_port_init(port, j);
        }
        device->ops = &usb_can_device_ops;
    }
}

void usb_can_free(struct can_device * device) {
    struct can_device_port * port = device->ports;
    for(unsigned int i = 0; i < USB_CAN_PORT_MAX; ++i, ++port) {
        free(port);
    }
    free(device);
}

bool usb_can_start(struct can_device * device) {
    bool status = false;
    status = device->ops->open(device);
    debug_info("usb_can_start , open result: %d", status);
    // if(status) {
        status = device->ops->init(device, USB_CAN_PORT_0);
        debug_info("usb_can_start , init port0 result: %d", status);
        status = device->ops->init(device, USB_CAN_PORT_1);
        debug_info("usb_can_start , init port1 result: %d", status);
    // }
    // if(status) {
        status = device->ops->start(device, USB_CAN_PORT_0);
        debug_info("usb_can_start , start port0 result: %d", status);
        status = device->ops->start(device, USB_CAN_PORT_1);
        debug_info("usb_can_start , start port1 result: %d", status);
    // }
    return status;
}

bool usb_can_stop(struct can_device * device) {
    bool status = device->ops->close(device);
    return status;
}

bool usb_can_send(struct can_device * device, unsigned int port_idx, PVCI_CAN_OBJ pObj, unsigned int len) {
    return device->ops->send(device, port_idx, pObj, len);
}

unsigned int usb_can_receive(struct can_device * device, unsigned int port_idx, PVCI_CAN_OBJ pObj, unsigned int len, int wait_time) {
    return device->ops->recv(device, port_idx, pObj, len, wait_time);
}


static int print_devs(libusb_device **devs)
{
	libusb_device *dev;
	int i = 0, j = 0;
	uint8_t path[8];
    int device_count = 0;

	while ((dev = devs[i++]) != NULL) {
		struct libusb_device_descriptor desc;
		int r = libusb_get_device_descriptor(dev, &desc);
		if (r < 0) {
			debug_info("failed to get device descriptor");
			return 0;
		}

		debug_info("%04x:%04x (bus %d, device %d)",
			desc.idVendor, desc.idProduct,
			libusb_get_bus_number(dev), libusb_get_device_address(dev));

        if(desc.idVendor == 0x04d8 && desc.idProduct == 0x0053) device_count++;
		r = libusb_get_port_numbers(dev, path, sizeof(path));
		if (r > 0) {
			debug_info(" path: %d", path[0]);
			for (j = 1; j < r; j++)
				debug_info(".%d", path[j]);
		}
		debug_info("\n");
	}
    return device_count;
}

int usb_can_device_init() {
	return libusb_init(NULL);
}

void usb_can_device_exit() {
	libusb_exit(NULL);
}

int usb_can_device_count() {
	libusb_device **devs;
	ssize_t cnt;
    int device_count = 0;

	cnt = libusb_get_device_list(NULL, &devs);
	if (cnt < 0){
		libusb_exit(NULL);
		return (int) cnt;
	}

	device_count = print_devs(devs);
	libusb_free_device_list(devs, 1);

    return device_count;
}
