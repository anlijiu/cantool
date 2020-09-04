#include <can/can_plugin.h>

#include <flutter_linux/flutter_linux.h>
#include <gtk/gtk.h>

#include <sys/utsname.h>
#include <memory>
#include <sstream>
#include "log.h"
#include "can_operator.h"
#include "controlcan.h"
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

const char kSetConstStrategy[] = "Can.SetConstStrategy";
const char kCanReceiveCallbackMethod[] = "Can.ReceiveCallback";

static FlMethodChannel *channel;

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


static bool can_receiver_cb(FlValue * result) {
  fl_method_channel_invoke_method(channel, kCanReceiveCallbackMethod,
                                     result, nullptr, nullptr, nullptr);
  return true;
}


static FlMethodResponse *open_can(FLCanPlugin *self,
                                  FlValue *args)
{
  debug_info("open_can  in");
  bool result = can_operator_init();
  can_operator_add_listener(can_receiver_cb);
  return FL_METHOD_RESPONSE(fl_method_success_response_new(fl_value_new_bool(result)));
}

static FlMethodResponse *close_can(FLCanPlugin *self,
                                   FlValue *args)
{
  debug_info("close_can  in");
  can_operator_remove_listener(can_receiver_cb);
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

static FlMethodResponse *sync_meta_data(FLCanPlugin *self, FlValue *args) {
  bool result = dbc_parser_sync_meta_data(args);

  if(result) {
    return FL_METHOD_RESPONSE(fl_method_success_response_new(nullptr));
  } else {
    return FL_METHOD_RESPONSE(fl_method_error_response_new("sync meta error", nullptr, nullptr));
  }

}

static FlMethodResponse *fire(FLCanPlugin *self, FlValue *args) {
  can_operator_fire();
  return FL_METHOD_RESPONSE(fl_method_success_response_new(nullptr));
}

static FlMethodResponse *ceasefire(FLCanPlugin *self, FlValue *args) {
  can_operator_ceasefire();
  return FL_METHOD_RESPONSE(fl_method_success_response_new(nullptr));
}

static FlMethodResponse *add_ammo(FLCanPlugin *self, FlValue *args) {
  if (fl_value_get_type(args) == FL_VALUE_TYPE_LIST) {
    size_t length = fl_value_get_length(args);
    for (size_t i = 0; i < length; ++i) {
      FlValue* m = fl_value_get_list_value(args, i);
      uint32_t id = fl_value_get_int(m);
      can_operator_add_message(id);
    }
    return FL_METHOD_RESPONSE(fl_method_success_response_new(nullptr));
  } else {
    return FL_METHOD_RESPONSE(fl_method_error_response_new("add ammo error", nullptr, nullptr));
  }

}

static FlMethodResponse *remove_ammo(FLCanPlugin *self, FlValue *args) {
  if (fl_value_get_type(args) == FL_VALUE_TYPE_LIST) {
    size_t length = fl_value_get_length(args);
    for (size_t i = 0; i < length; ++i) {
      FlValue* m = fl_value_get_list_value(args, i);
      uint32_t id = fl_value_get_int(m);
      can_operator_remove_message(id);
    }
    return FL_METHOD_RESPONSE(fl_method_success_response_new(nullptr));
  } else {
    return FL_METHOD_RESPONSE(fl_method_error_response_new("remove ammo error", nullptr, nullptr));
  }
}

static FlMethodResponse *set_const_strategy(FLCanPlugin *self, FlValue *args) {
  if (fl_value_get_type(args) == FL_VALUE_TYPE_MAP) {
    FlValue * sname = fl_value_lookup_string(args, "name");
    FlValue * svalue = fl_value_lookup_string(args, "value");
    const char* name = fl_value_get_string(sname);
    double value = fl_value_get_float(svalue);
    can_operator_add_const_signal_builder(name, value);
    return FL_METHOD_RESPONSE(fl_method_success_response_new(nullptr));
  } else {
    return FL_METHOD_RESPONSE(fl_method_error_response_new("remove ammo error", nullptr, nullptr));
  }
}


// Called when a method call is received from Flutter.
static void method_call_cb(FlMethodChannel *channel, FlMethodCall *method_call,
                           gpointer user_data)
{
  FLCanPlugin *self = FL_CAN_PLUGIN(user_data);

  const gchar *method = fl_method_call_get_name(method_call);
  FlValue *args = fl_method_call_get_args(method_call);

  g_autoptr(FlMethodResponse) response = nullptr;
  if (strcmp(method, kOpenDeviceMethod) == 0) {
    response = open_can(self, args);
  } else if (strcmp(method, kCloseDeviceMethod) == 0) {
    response = close_can(self, args);
  } else if (strcmp(method, kParseDbcFileMethod) == 0) {
    response = parse_dbc_by_path(self, args);
  } else if (strcmp(method, kSyncMetaDatas) == 0) {
    response = sync_meta_data(self, args);
  } else if (strcmp(method, kFire) == 0) {
    response = fire(self, args);
  } else if (strcmp(method, kCeaseFire) == 0) {
    response = ceasefire(self, args);
  } else if (strcmp(method, kAddAmmo) == 0) {
    response = add_ammo(self, args);
  } else if (strcmp(method, kRemoveAmmo) == 0) {
    response = remove_ammo(self, args);
  } else if (strcmp(method, kSetConstStrategy) == 0) {
    response = set_const_strategy(self, args);
  } else {
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
  channel = self->channel;
  GtkWindow *window = get_window(self);
    g_signal_connect(G_OBJECT(window),
        "destroy", can_destroy, NULL);

  g_message("\nfl_can_plugin_new end\n");
  return self;
}

void can_plugin_register_with_registrar(FlPluginRegistrar *registrar)
{
  FLCanPlugin *plugin = fl_can_plugin_new(registrar);
  g_object_unref(plugin);
}
