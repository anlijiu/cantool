#include "device.h"

#include <string.h>
#include <stdio.h>

static devices_map devices;

static on_recv_fun_t s_onrecv;

void set_bittiming(enum BAUDRATE baudrate) {
    struct can_device* dev;
    hashmap_foreach_data(dev, &devices) {
        dev->ops->set_bittiming(dev, baudrate);
    }
}

void set_data_bittiming(enum BAUDRATE baudrate) {
    struct can_device* dev;
    hashmap_foreach_data(dev, &devices) {
        dev->ops->set_data_bittiming(dev, baudrate);
    }
}

void send_can_frame(struct can_frame_s * frame, unsigned int len) {
    struct can_device* dev;
    hashmap_foreach_data(dev, &devices) {
        dev->ops->send(dev, frame, len);
    }
}
void send_canfd_frame(struct canfd_frame_s * frame, unsigned int len) {
    struct can_device* dev;
    hashmap_foreach_data(dev, &devices) {
        if(dev->ops->sendfd) {
            dev->ops->sendfd(dev, frame, len);
        }
    }
}

void set_receive_listener(on_recv_fun_t onrecv) {
    struct can_device* dev;
    s_onrecv = onrecv;
    hashmap_foreach_data(dev, &devices) {
        if(dev->ops->set_receive_listener) {
            dev->ops->set_receive_listener(dev, onrecv);
        }
    }
}

void set_canfd_receive_listener(on_canfd_recv_fun_t onrecv) {
    struct can_device* dev;
    hashmap_foreach_data(dev, &devices) {
        if(dev->ops->set_canfd_receive_listener) {
            dev->ops->set_canfd_receive_listener(dev, onrecv);
        }
    }
}

void add_device(struct can_device* dev) {
    printf("%s start , uuid:%s\n", __func__, dev->uuid);
    hashmap_put(&devices, dev->uuid, dev);

    hashmap_foreach_data(dev, &devices) {
        if(dev->ops->set_receive_listener) {
            dev->ops->set_receive_listener(dev, s_onrecv);
        }
    }
}

void remove_device(struct can_device* dev) {
    hashmap_remove(&devices, dev->uuid);
}

void init_devices() {
    hashmap_init(&devices, hashmap_hash_string, strcmp);
}
