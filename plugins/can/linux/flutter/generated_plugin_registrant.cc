//
//  Generated file. Do not edit.
//

#include "generated_plugin_registrant.h"

#include <can/can_plugin.h>

void fl_register_plugins(FlPluginRegistry* registry) {
  g_autoptr(FlPluginRegistrar) can_registrar =
      fl_plugin_registry_get_registrar_for_plugin(registry, "CanPlugin");
  can_plugin_register_with_registrar(can_registrar);
}
