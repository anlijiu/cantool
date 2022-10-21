#ifndef __BUS_H__
#define __BUS_H__

#ifdef __cplusplus
extern "C" {
#endif

void init_buses();
void fini_buses();
void register_usb_hotplugin(int (*probe)(), int vendor_id, int product_id);
void register_usb_hotplugout(int (*remove)(), int vendor_id, int product_id);

#ifdef __cplusplus
}
#endif

#endif //__BUS_H__
