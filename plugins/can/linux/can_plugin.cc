#include <can/can_plugin.h>

#include <flutter_linux/flutter_linux.h>
#include <gtk/gtk.h>

#include <sys/utsname.h>
#include <memory>
#include <sstream>
#include "log.h"
#include "can_operator.h"
#include "dbc_parser.h"

// See channel_controller.dart for documentation.
const char kChannelName[] = "flutter/can_channel";

const char kOpenDeviceMethod[] = "Can.OpenDevice";
const char kCloseDeviceMethod[] = "Can.CloseDevice";

const char kFire[] = "Can.Fire";
const char kCeaseFire[] = "Can.CeaseFire";

const char kAddAmmo[] = "Can.AddAmmo";
const char kRemoveAmmo[] = "Can.RemomveAmmo";

const char kParseDbcFileMethod[] = "Can.ParseDbcFile";
const char kSyncMetaDatas[] = "Can.SyncMetaDatas";

struct _FLCanPlugin
{
  GObject parent_instance;

  FlPluginRegistrar *registrar;

  // Connection to Flutter engine.
  FlMethodChannel *channel;

  // Dialog currently being shown.
  // GtkColorChooserDialog* color_chooser_dialog;
};

G_DEFINE_TYPE(FLCanPlugin, fl_can_plugin, g_object_get_type())

// Gets the window being controlled.
GtkWindow *get_window(FLCanPlugin *self)
{
  FlView *view = fl_plugin_registrar_get_view(self->registrar);
  if (view == nullptr)
    return nullptr;

  return GTK_WINDOW(gtk_widget_get_toplevel(GTK_WIDGET(view)));
}

static FlMethodResponse *open_can(FLCanPlugin *self,
                                  FlValue *args)
{
  debug_info("open_can  in");
  bool result = can_operator_init();
  return FL_METHOD_RESPONSE(fl_method_success_response_new(fl_value_new_bool(result)));
}

static FlMethodResponse *close_can(FLCanPlugin *self,
                                   FlValue *args)
{
  debug_info("close_can  in");
  can_operator_destroy();
  return FL_METHOD_RESPONSE(fl_method_success_response_new(nullptr));
}

static FlMethodResponse *parse_dbc_by_path(FLCanPlugin *self, FlValue *args) {
    g_autoptr(FlValue) result = fl_value_new_map();

    if (fl_value_get_type(args) == FL_VALUE_TYPE_STRING) {
      const gchar* path = fl_value_get_string(args);
      debug_info("parse_dbc  in path:%s", path);
      parse_dbc(path, result);
    }
    fl_value_set_string_take(result, "test3", fl_value_new_string("test3"));
    return FL_METHOD_RESPONSE(fl_method_success_response_new(result));
}

// Called when a method call is received from Flutter.
static void method_call_cb(FlMethodChannel *channel, FlMethodCall *method_call,
                           gpointer user_data)
{
  FLCanPlugin *self = FL_CAN_PLUGIN(user_data);

  const gchar *method = fl_method_call_get_name(method_call);
  FlValue *args = fl_method_call_get_args(method_call);

  g_autoptr(FlMethodResponse) response = nullptr;
  if (strcmp(method, kOpenDeviceMethod) == 0)
  {
    response = open_can(self, args);
  }
  else if (strcmp(method, kCloseDeviceMethod) == 0)
  {
    response = close_can(self, args);
  }
  else if (strcmp(method, kParseDbcFileMethod) == 0)
  {
    response = parse_dbc_by_path(self, args);
  }
  else if (strcmp(method, kFire) == 0)
  {
  }
  else if (strcmp(method, kCeaseFire) == 0)
  {
  }
  else if (strcmp(method, kAddAmmo) == 0)
  {
  }
  else if (strcmp(method, kRemoveAmmo) == 0)
  {
  }
  else
  {
    response = FL_METHOD_RESPONSE(fl_method_not_implemented_response_new());
  }

  g_autoptr(GError) error = nullptr;
  if (!fl_method_call_respond(method_call, response, &error))
    g_warning("Failed to send method call response: %s", error->message);
}

static void fl_can_plugin_init(FLCanPlugin *self)
{
  g_message("fl_can_plugin_init  in");
}

static void fl_can_plugin_class_init(FLCanPluginClass *klass)
{
  g_message("fl_can_plugin_class_init in");
  // G_OBJECT_CLASS(klass)->dispose = fl_color_panel_plugin_dispose;
}

static void can_destroy() {
  g_message("\n\ncan_destroy in\n\n");
}

FLCanPlugin *fl_can_plugin_new(FlPluginRegistrar *registrar)
{
  g_message("fl_can_plugin_new in");
  FLCanPlugin *self = FL_CAN_PLUGIN(
      g_object_new(fl_can_plugin_get_type(), nullptr));

  self->registrar = FL_PLUGIN_REGISTRAR(g_object_ref(registrar));

  g_autoptr(FlStandardMethodCodec) codec = fl_standard_method_codec_new();
  self->channel =
      fl_method_channel_new(fl_plugin_registrar_get_messenger(registrar),
                            kChannelName, FL_METHOD_CODEC(codec));
  fl_method_channel_set_method_call_handler(self->channel, method_call_cb,
                                            g_object_ref(self), g_object_unref);

  GtkWindow *window = get_window(self);
    g_signal_connect(G_OBJECT(window),
        "destroy", can_destroy, NULL);
  return self;
}

void can_plugin_register_with_registrar(FlPluginRegistrar *registrar)
{
  FLCanPlugin *plugin = fl_can_plugin_new(registrar);
  g_object_unref(plugin);
}
