#ifndef PLUGINS_CAN_LINUX_USB_CAN_H_
#define PLUGINS_CAN_LINUX_USB_CAN_H_

#include <flutter_plugin_registrar.h>

G_BEGIN_DECLS

#ifdef FLUTTER_PLUGIN_IMPL
#define FLUTTER_PLUGIN_EXPORT __attribute__((visibility("default")))
#else
#define FLUTTER_PLUGIN_EXPORT
#endif


G_DECLARE_FINAL_TYPE(FlUsbCanPlugin, fl_usb_can_plugin, FL,
                     USB_CAN_PLUGIN, GObject)

FLUTTER_PLUGIN_EXPORT FlUsbCanPlugin* fl_usb_can_plugin_new(
    FlPluginRegistrar* registrar);

FLUTTER_PLUGIN_EXPORT void usb_can_plugin_register_with_registrar(
    FlPluginRegistrar* registrar);

G_END_DECLS


#endif  // PLUGINS_CAN_LINUX_USB_CAN_H_
