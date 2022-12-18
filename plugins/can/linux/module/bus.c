#include "bus.h"
#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>
#include <pthread.h>
#include "libusb.h"
#include "thread_pool.h"

static bool g_hotplug_enable = true;

static int LIBUSB_CALL hotplug_callback(libusb_context *ctx, libusb_device *dev, libusb_hotplug_event event, void *user_data)
{
    int (*callback)()  = user_data;
    callback();
    printf("%s begin\n", __func__);
    return 0;
}

static void handle_libusb_event_loop_task(void *arg){
    int rc;
    while(g_hotplug_enable) {
		rc = libusb_handle_events (NULL);
		if (rc < 0)
			printf("libusb_handle_events() failed: %s\n", libusb_error_name(rc));
    }
}


void init_usb_bus() {
	int rc = libusb_init (NULL);
    // thread_pool_add_work(handle_libusb_event_loop_task, NULL);
}

void fini_usb_bus() {
    printf("%s begin\n", __func__);
    g_hotplug_enable = false;
    libusb_exit(NULL);
}

void register_usb_hotplugin(int (*probe)(), int vendor_id, int product_id) {
    printf("%s begin\n", __func__);
    int class_id = LIBUSB_HOTPLUG_MATCH_ANY;
    libusb_hotplug_callback_handle * hp = calloc(sizeof(libusb_hotplug_callback_handle), 1);
    int rc = libusb_hotplug_register_callback (NULL, LIBUSB_HOTPLUG_EVENT_DEVICE_ARRIVED, 0, vendor_id,
		product_id, class_id, hotplug_callback, probe, hp);
}

void register_usb_hotplugout(int (*remove)(), int vendor_id, int product_id) {
    printf("%s begin\n", __func__);
    int class_id = LIBUSB_HOTPLUG_MATCH_ANY;
    libusb_hotplug_callback_handle * hp = calloc(sizeof(libusb_hotplug_callback_handle), 1);
    int rc = libusb_hotplug_register_callback (NULL, LIBUSB_HOTPLUG_EVENT_DEVICE_LEFT, 0, vendor_id,
		product_id, class_id, hotplug_callback, remove, hp);
}

void init_buses() {
    printf("%s begin\n", __func__);
    init_usb_bus();
}

void fini_buses() {
    printf("%s begin\n", __func__);
    fini_usb_bus();
}
