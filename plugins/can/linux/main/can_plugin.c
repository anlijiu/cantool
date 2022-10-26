#include <can/can_plugin.h>

#include <flutter_linux/flutter_linux.h>
#include <gtk/gtk.h>

#include <sys/utsname.h>
// #include <memory>
// #include <sstream>
#include "log.h"
#include "thread_pool.h"
#include "bus.h"
#include "device.h"
#include "can_operator.h"
#include "replay_operator.h"
#include "driver_manage.h"
#include "dbc_parser.h"
#include "frame_to_flvalue.h"


// See channel_controller.dart for documentation.
const char kChannelName[] = "flutter/can_channel";
const char kCanTraceChannelName[] = "flutter/can_trace_channel";

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
const char kCanFdReceiveCallbackMethod[] = "CanFD.ReceiveCallback";

const char kReplaySetFile[] = "Can.ReplaySetFile";
const char kReplayGetFiltedSignals[] = "Can.ReplayGetFiltedSignals";
const char kReplayParseFiltedSignals[] = "Can.ReplayParseFiltedSignals";

static FlMethodChannel *channel;
static FlEventChannel *event_channel;
static bool is_send_events = true;

#define CAN_PLUGIN(obj) \
  (G_TYPE_CHECK_INSTANCE_CAST((obj), can_plugin_get_type(), \
                              CanPlugin))

struct _CanPlugin
{
  GObject parent_instance;

  FlPluginRegistrar *registrar;

  // Connection to Flutter engine.
  FlMethodChannel *channel;

  FlEventChannel* event_channel;

  // Dialog currently being shown.
  // GtkColorChooserDialog* color_chooser_dialog;
};

G_DEFINE_TYPE(CanPlugin, can_plugin, g_object_get_type())

// Gets the window being controlled.
GtkWindow *get_window(CanPlugin *self)
{
  FlView *view = fl_plugin_registrar_get_view(self->registrar);
  if (view == NULL)
    return NULL;

  return GTK_WINDOW(gtk_widget_get_toplevel(GTK_WIDGET(view)));
}


static int can_receiver_cb(char* uuid, struct can_frame_s *frame, unsigned int num) {

  g_autoptr(FlValue) result = fl_value_new_list();
  can_frame_to_flvalue(frame, num, result);
// static bool can_receiver_cb(FlValue * result) {
  // debug_info("can_plugin.cc   can_receiver_cb");
  fl_method_channel_invoke_method(channel, kCanReceiveCallbackMethod,
                                     result, NULL, NULL, NULL);
  return true;
}
static int canfd_receiver_cb(char* uuid, struct canfd_frame_s *frame, unsigned int num) {

  debug_info("canfd_receiver_cb  receive %u frame\n", num);
  g_autoptr(FlValue) result = fl_value_new_list();

  canfd_frame_to_flvalue(frame, num, result);
// static bool can_receiver_cb(FlValue * result) {
  // debug_info("can_plugin.cc   can_receiver_cb");
  fl_method_channel_invoke_method(channel, kCanReceiveCallbackMethod,
                                     result, NULL, NULL, NULL);
  return true;
}


static FlMethodResponse *open_can(CanPlugin *self,
                                  FlValue *args)
{
  debug_info("open_can in");
  bool result = can_operator_init();
  can_operator_add_listener(can_receiver_cb);
  can_operator_add_canfd_listener(canfd_receiver_cb);
  return FL_METHOD_RESPONSE(fl_method_success_response_new(fl_value_new_bool(result)));
}

static FlMethodResponse *close_can(CanPlugin *self,
                                   FlValue *args)
{
  debug_info("close_can in");
  can_operator_remove_listener(can_receiver_cb);
  can_operator_remove_canfd_listener(canfd_receiver_cb);
  can_operator_destroy();
  return FL_METHOD_RESPONSE(fl_method_success_response_new(NULL));
}

static FlMethodResponse *parse_dbc_by_path(CanPlugin *self, FlValue *args) {
    g_autoptr(FlValue) result = fl_value_new_map();

    if (fl_value_get_type(args) == FL_VALUE_TYPE_STRING) {
      const gchar* path = fl_value_get_string(args);
      debug_info("parse_dbc  in path:%s", path);
      parse_dbc(path, result);
    }
    fl_value_set_string_take(result, "test3", fl_value_new_string("test3"));
    return FL_METHOD_RESPONSE(fl_method_success_response_new(result));
}

static FlMethodResponse *sync_meta_data(CanPlugin *self, FlValue *args) {
  bool result = dbc_parser_sync_meta_data(args);

  if(result) {
    return FL_METHOD_RESPONSE(fl_method_success_response_new(NULL));
  } else {
    return FL_METHOD_RESPONSE(fl_method_error_response_new("sync meta error", NULL, NULL));
  }

}

static FlMethodResponse *fire(CanPlugin *self, FlValue *args) {
  can_operator_fire();
  return FL_METHOD_RESPONSE(fl_method_success_response_new(NULL));
}

static FlMethodResponse *ceasefire(CanPlugin *self, FlValue *args) {
  can_operator_ceasefire();
  return FL_METHOD_RESPONSE(fl_method_success_response_new(NULL));
}

static FlMethodResponse *add_ammo(CanPlugin *self, FlValue *args) {
  if (fl_value_get_type(args) == FL_VALUE_TYPE_LIST) {
    size_t length = fl_value_get_length(args);
    for (size_t i = 0; i < length; ++i) {
      FlValue* m = fl_value_get_list_value(args, i);
      uint32_t id = fl_value_get_int(m);
      can_operator_add_message(id);
    }
    return FL_METHOD_RESPONSE(fl_method_success_response_new(NULL));
  } else {
    return FL_METHOD_RESPONSE(fl_method_error_response_new("add ammo error", NULL, NULL));
  }

}

static FlMethodResponse *remove_ammo(CanPlugin *self, FlValue *args) {
  if (fl_value_get_type(args) == FL_VALUE_TYPE_LIST) {
    size_t length = fl_value_get_length(args);
    for (size_t i = 0; i < length; ++i) {
      FlValue* m = fl_value_get_list_value(args, i);
      uint32_t id = fl_value_get_int(m);
      can_operator_remove_message(id);
    }
    return FL_METHOD_RESPONSE(fl_method_success_response_new(NULL));
  } else {
    return FL_METHOD_RESPONSE(fl_method_error_response_new("remove ammo error", NULL, NULL));
  }
}

static FlMethodResponse *set_const_strategy(CanPlugin *self, FlValue *args) {
  if (fl_value_get_type(args) == FL_VALUE_TYPE_MAP) {
    FlValue * sname = fl_value_lookup_string(args, "name");
    FlValue * svalue = fl_value_lookup_string(args, "value");
    const char* name = fl_value_get_string(sname);
    double value = fl_value_get_float(svalue);
    can_operator_add_const_signal_builder(name, value);
    return FL_METHOD_RESPONSE(fl_method_success_response_new(NULL));
  } else {
    return FL_METHOD_RESPONSE(fl_method_error_response_new("remove ammo error", NULL, NULL));
  }
}

static FlMethodResponse *replay_set_file(CanPlugin *self, FlValue *args) {
    if (fl_value_get_type(args) == FL_VALUE_TYPE_STRING) {
        const char* path = fl_value_get_string(args);
        replay_operator_set_file_path(path);
    }
    return FL_METHOD_RESPONSE(fl_method_success_response_new(NULL));
}
static FlMethodResponse *replay_get_filted_signals(CanPlugin *self, FlValue *args) {
    g_autoptr(FlValue) result = fl_value_new_map();

    if (fl_value_get_type(args) == FL_VALUE_TYPE_LIST) {
        replay_operator_get_filted_signals(args, result);
    }
    return FL_METHOD_RESPONSE(fl_method_success_response_new(result));
}

static void send_trace_event(FlValue* event) {
  if (!is_send_events) {
    return;
  }

  // g_autoptr(FlValue) event = fl_value_new_map();
  // fl_value_set_string_take(event, "type", fl_value_new_string("FromLinux"));
  // fl_value_set_string_take(event, "time", fl_value_new_int(time(NULL)));

  fl_event_channel_send(event_channel, event, NULL, NULL);
}


static FlMethodResponse *replay_parse_filted_signals(CanPlugin *self, FlValue *args) {
    if (fl_value_get_type(args) == FL_VALUE_TYPE_LIST) {
        replay_operator_parse_filted_signals(args, send_trace_event);
    }
    return FL_METHOD_RESPONSE(fl_method_success_response_new(NULL));
}


// Called when a method call is received from Flutter.
static void method_call_cb(FlMethodChannel *channel, FlMethodCall *method_call,
                           gpointer user_data)
{
  CanPlugin *self = CAN_PLUGIN(user_data);

  const gchar *method = fl_method_call_get_name(method_call);
  FlValue *args = fl_method_call_get_args(method_call);

  g_autoptr(FlMethodResponse) response = NULL;
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
  } else if (strcmp(method, kReplaySetFile) == 0) {
    response = replay_set_file(self, args);
  } else if (strcmp(method, kReplayGetFiltedSignals) == 0) {
    response = replay_get_filted_signals(self, args);
  } else if (strcmp(method, kReplayParseFiltedSignals) == 0) {
    response = replay_parse_filted_signals(self, args);
  } else {
    response = FL_METHOD_RESPONSE(fl_method_not_implemented_response_new());
  }

  g_autoptr(GError) error = NULL;
  if (!fl_method_call_respond(method_call, response, &error))
    g_warning("Failed to send method call response: %s", error->message);
}

static FlMethodErrorResponse* event_channel_listen_cb(FlEventChannel* channel,
                                                      FlValue* args,
                                                      gpointer user_data) {
  is_send_events = true;
  return NULL;
}

static FlMethodErrorResponse* event_channel_cancel_cb(FlEventChannel* channel,
                                                      FlValue* args,
                                                      gpointer user_data) {
  is_send_events = false;
  return NULL;
}

static void can_plugin_init(CanPlugin *self)
{
  g_message("can_plugin_init  in");
}

static void can_plugin_class_init(CanPluginClass *klass)
{
  g_message("can_plugin_class_init in");
  // G_OBJECT_CLASS(klass)->dispose = fl_color_panel_plugin_dispose;
}

static void can_destroy() {
  unload_drivers();
  fini_buses();
  thread_pool_fini();
  g_message("\n\ncan_destroy in\n\n");
}

CanPlugin *can_plugin_new(FlPluginRegistrar *registrar)
{
  // 关于本plugin 一切的入口 需要做的事:
  // 1. 注册hot plugin  ， 发现支持的设备usbcanII 或者trcan的时候 用默认参数初始化该设备
  // 2. 查询当前的usb设备是否存在 存在的话用默认参数初始化该设备
  //
  g_message("can_plugin_new in");
  CanPlugin *self = CAN_PLUGIN(
      g_object_new(can_plugin_get_type(), NULL));

  self->registrar = FL_PLUGIN_REGISTRAR(g_object_ref(registrar));

  g_autoptr(FlStandardMethodCodec) codec = fl_standard_method_codec_new();
  self->channel =
      fl_method_channel_new(fl_plugin_registrar_get_messenger(registrar),
                            kChannelName, FL_METHOD_CODEC(codec));
  fl_method_channel_set_method_call_handler(self->channel, method_call_cb,
                                            g_object_ref(self), g_object_unref);
  channel = self->channel;

  self->event_channel = fl_event_channel_new(
      fl_plugin_registrar_get_messenger(registrar),
      kCanTraceChannelName,
      FL_METHOD_CODEC(codec));
  fl_event_channel_set_stream_handlers(
      self->event_channel, event_channel_listen_cb, event_channel_cancel_cb,
      NULL, NULL);
  event_channel = self->event_channel;




  GtkWindow *window = get_window(self);
    g_signal_connect(G_OBJECT(window),
        "destroy", can_destroy, NULL);

  init_dbc_parser();
  thread_pool_init();
  init_buses();
  init_devices();
  load_drivers();

  g_message("\ncan_plugin_new end\n");
  return self;
}

void can_plugin_register_with_registrar(FlPluginRegistrar *registrar)
{
  CanPlugin *plugin = can_plugin_new(registrar);
  g_object_unref(plugin);
}
