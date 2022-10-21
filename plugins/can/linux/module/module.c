#include "module.h"
#include <stdio.h>
#include "bus.h"
// void register_usb_hotplug(int vendor_id, int product_id) {

int usb_driver_register(struct usb_can_driver *driver) {
    printf("%s begin\n", __func__);
    driver->init();

    const struct usb_device_id *ids;
    for (ids = driver->id_table; ids->idVendor; ids++) {
        register_usb_hotplugin(driver->probe, ids->idVendor, ids->idProduct);
        register_usb_hotplugout(driver->remove, ids->idVendor, ids->idProduct);
    }
    return 0;
}

void usb_driver_unregister(struct usb_can_driver *driver) {
    driver->exit();
    printf("%s begin\n", __func__);
}

void add_can_device(struct can_device *dev) {
    printf("%s begin\n", __func__);
}

void remove_can_device(struct can_device *dev) {
    printf("%s begin\n", __func__);
}


// int can_driver_probe(struct can_driver *drv,
//  int (*probe)(struct can_device *)) {
// }
// 
// int can_driver_remove(struct can_driver *drv) {
// }
