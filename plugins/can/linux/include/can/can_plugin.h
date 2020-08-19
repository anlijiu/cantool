#ifndef PLUGINS_CAN_LINUX_CAN_H_
#define PLUGINS_CAN_LINUX_CAN_H_

#include <flutter_linux/flutter_linux.h>

G_BEGIN_DECLS

#ifdef FLUTTER_PLUGIN_IMPL
#define FLUTTER_PLUGIN_EXPORT __attribute__((visibility("default")))
#else
#define FLUTTER_PLUGIN_EXPORT
#endif


G_DECLARE_FINAL_TYPE(FLCanPlugin, fl_can_plugin, FL,
                     CAN_PLUGIN, GObject)

FLUTTER_PLUGIN_EXPORT FLCanPlugin* fl_can_plugin_new(
    FlPluginRegistrar* registrar);

FLUTTER_PLUGIN_EXPORT void can_plugin_register_with_registrar(
    FlPluginRegistrar* registrar);

G_END_DECLS


#endif  // PLUGINS_CAN_LINUX_CAN_H_
