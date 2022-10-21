#ifndef __DEVICE_H__
#define __DEVICE_H__

#include <stdint.h>
#include <stdbool.h>
#include <pthread.h>
#include "can_defs.h"
#include "hashmap/hashmap.h"
#include "list/list.h"

#ifdef __cplusplus
extern "C" {
#endif

struct can_device;
struct can_device_ops;


#define USB_DEVICE_ID_MATCH_VENDOR		0x0001
#define USB_DEVICE_ID_MATCH_PRODUCT		0x0002
#define USB_DEVICE_ID_MATCH_DEVICE \
		(USB_DEVICE_ID_MATCH_VENDOR | USB_DEVICE_ID_MATCH_PRODUCT)
struct usb_device_id {
	uint16_t match_flags;
	uint16_t idVendor;
	uint16_t idProduct;
};

#define USB_DEVICE(vend, prod) \
	.match_flags = USB_DEVICE_ID_MATCH_DEVICE, \
	.idVendor = (vend), \
	.idProduct = (prod)

struct usb_can_driver {
    const char *name;
    int (*init)();
    void (*exit)();
    int (*probe)();
    int (*remove)();
	const struct usb_device_id *id_table;
};

typedef int (*on_recv_fun_t)(char* uuid, struct can_frame_s *, unsigned int num);
typedef int (*on_canfd_recv_fun_t)(char* uuid, struct canfd_frame_s *, unsigned int num);

struct can_device_ops {
	int (*set_bittiming)(struct can_device *dev, enum BAUDRATE baudrate);
	int (*set_data_bittiming)(struct can_device *dev, enum BAUDRATE baudrate);
	int (*set_receive_listener)(struct can_device *, on_recv_fun_t onrecv);
	int (*set_canfd_receive_listener)(struct can_device *, on_canfd_recv_fun_t onrecv);
	bool (*send)(struct can_device *, can_frame_t *frame, unsigned int len);
	bool (*sendfd)(struct can_device *, canfd_frame_t *frame, unsigned int len);
};


struct can_device {
	const char	*name;
    char uuid[40];
    bool support_canfd;
	struct can_bittiming bittiming, data_bittiming;
    struct can_device_ops* ops;
};

typedef HASHMAP(char, struct can_device) devices_map;

void set_bittiming(enum BAUDRATE baudrate);
void set_data_bittiming(enum BAUDRATE baudrate);
void init_devices();
void send_can_frame(struct can_frame_s *, unsigned int len);
void send_canfd_frame(struct canfd_frame_s *, unsigned int len);
void set_receive_listener(on_recv_fun_t onrecv);
void set_canfd_receive_listener(on_canfd_recv_fun_t onrecv);
extern void add_device(struct can_device* dev);
extern void remove_device(struct can_device* dev);

#ifdef __cplusplus
}
#endif

#endif // __DEVICE_H__
