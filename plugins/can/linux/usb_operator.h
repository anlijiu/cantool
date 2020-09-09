#pragma once

#ifdef __cplusplus
extern "C" {
#endif

typedef bool (*usb_listener_t)(int deviceCount);


int usb_can_device_count();


#ifdef __cplusplus
}
#endif
