#ifndef __MODULE_H__
#define __MODULE_H__

#include <stdint.h>
#include <stdbool.h>
#include "device.h"

#include "compiler_attributes.h"

#ifdef __cplusplus
extern "C" {
#endif

extern int usb_driver_register(struct usb_can_driver *drv);
extern void usb_driver_unregister(struct usb_can_driver *drv);

extern void add_can_device(struct can_device *dev);
extern void remove_can_device(struct can_device *dev);

#ifdef __cplusplus
}
#endif

// extern void can_device_register(struct can_device *dev);
// extern void can_device_unregister(struct can_device *dev);
// 
// extern int can_driver_probe(struct can_driver *drv,
// 		int (*probe)(struct can_device *));
// 
// extern int can_driver_remove(struct can_driver *drv);

#define module_init(initfn)					\
	int __init init_module(void) __copy(initfn)			\
		__attribute__((alias(#initfn)));

#define module_exit(cleanfn)					\
	void __exit clean_module(void) __copy(cleanfn)			\
		__attribute__((alias(#cleanfn)));

#define module_driver(__driver, __register, __unregister, ...) \
static int __init __driver##_init(void) \
{ \
	return __register(&(__driver) , ##__VA_ARGS__); \
} \
module_init(__driver##_init); \
static void __exit __driver##_exit(void) \
{ \
	__unregister(&(__driver) , ##__VA_ARGS__); \
} \
module_exit(__driver##_exit);

#define module_usb_driver(__usb_driver) \
	module_driver(__usb_driver, usb_driver_register, \
			usb_driver_unregister)




#endif // __MODULE_H__
