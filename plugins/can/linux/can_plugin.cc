#include "usb_can_plugin.h"

#include <flutter_linux/flutter_linux.h>
#include <gtk/gtk.h>

#include <sys/utsname.h>
#include <memory>
#include <sstream>
#include "plugin_interface.h"
#include "weapon_controller.h"

namespace plugins_usb_can {

namespace {

using flutter::EncodableList;
using flutter::EncodableMap;
using flutter::EncodableValue;

// See channel_controller.dart for documentation.
const char kOpenDeviceMethod[] = "UsbCan.OpenDevice";

const char kDeviceNumber[] = "UsbCan.DeviceNumber";
const char kPortNumber[] = "UsbCan.PortNumber";



const char kChannelName[] = "flutter/usb_can";
const char kEventChannelName[] = "flutter/usb_can_event";
const char kSyncMetaDatas[] = "UsbCan.SyncMetaDatas";
const char kFire[] = "UsbCan.Fire";
const char kCeaseFire[] = "UsbCan.CeaseFire";
const char kSetAmmos[] = "UsbCan.SetAmmos";
const char kAddAmmo[] = "UsbCan.AddAmmo";
const char kRemoveAmmo[] = "UsbCan.RemomveAmmo";
const char kSetAmmoBuildStrategy[] = "UsbCan.SetAmmoBuildStrategy";

// Looks for |key| in |map|, returning the associated value if it is present, or
// a Null EncodableValue if not.
const EncodableValue &ValueOrNull(const EncodableMap &map, const char *key) {
  static EncodableValue null_value;
  auto it = map.find(EncodableValue(key));
  if (it == map.end()) {
    return null_value;
  }
  return it->second;
}

}  // namespace


struct _FlUsbCanPlugin {
  GObject parent_instance;

  FlPluginRegistrar* registrar;

  // Connection to Flutter engine.
  FlMethodChannel* channel;

  // Dialog currently being shown.
  // GtkColorChooserDialog* color_chooser_dialog;
};

G_DEFINE_TYPE(FlUsbCanPlugin, fl_usb_can_plugin, g_object_get_type())

static FlMethodResponse* open_usb_can(FlUsbCanPlugin* self,
                                          FlValue* args) {

  FlValue* device_value = nullptr;
  FlValue* port_value = nullptr;
  if (fl_value_get_type(args) == FL_VALUE_TYPE_MAP) {
    device_value = fl_value_lookup_string(args, kDeviceNumber);
    port_value = fl_value_lookup_string(args, kPortNumber);
  }
  gint device_type =
      device_value != nullptr ? fl_value_get_int(device_value) : 0;
  gint port_num =
      port_value != nullptr ? fl_value_get_int(port_value) : 0;
}

// Called when a method call is received from Flutter.
static void method_call_cb(FlMethodChannel* channel, FlMethodCall* method_call,
                           gpointer user_data) {
  FlUsbCanPlugin* self = FL_USB_CAN_PLUGIN(user_data);

  const gchar* method = fl_method_call_get_name(method_call);
  FlValue* args = fl_method_call_get_args(method_call);

  g_autoptr(FlMethodResponse) response = nullptr;
  if (strcmp(method, kOpenDeviceMethod) == 0) {
    response = open_usb_can(self, args);
  } else if (strcmp(method, kHideColorPanelMethod) == 0) {
    response = hide_color_panel(self);
  } else {
    response = FL_METHOD_RESPONSE(fl_method_not_implemented_response_new());
  }

  g_autoptr(GError) error = nullptr;
  if (!fl_method_call_respond(method_call, response, &error))
    g_warning("Failed to send method call response: %s", error->message);
}

static void fl_usb_can_plugin_init(FlUsbCanPlugin* self) {
  g_message("fl_usb_can_plugin_init  in");
}

static void fl_usb_can_plugin_class_init(FlUsbCanPluginClass* klass) {
  g_message("fl_usb_can_plugin_class_init in");
  G_OBJECT_CLASS(klass)->dispose = fl_color_panel_plugin_dispose;
}

FlUsbCanPlugin* fl_usb_can_plugin_new(FlPluginRegistrar* registrar) {
  FlUsbCanPlugin* self = FL_USB_CAN_PLUGIN(
      g_object_new(fl_usb_can_plugin_get_type(), nullptr));

  self->registrar = FL_PLUGIN_REGISTRAR(g_object_ref(registrar));

  g_autoptr(FlStandardMethodCodec) codec = fl_standard_method_codec_new();
  self->channel =
      fl_method_channel_new(fl_plugin_registrar_get_messenger(registrar),
                            kChannelName, FL_METHOD_CODEC(codec));
  fl_method_channel_set_method_call_handler(self->channel, method_call_cb,
                                            g_object_ref(self), g_object_unref);

  return self;
}

void usb_can_plugin_register_with_registrar(FlPluginRegistrar* registrar) {
  FlUsbCanPlugin* plugin = fl_usb_can_plugin_new(registrar);
  g_object_unref(plugin);
}





class UsbCan : public flutter::Plugin {
 public:
  static void RegisterWithRegistrar(flutter::PluginRegistrar *registrar);

  // Creates a plugin that communicates on the given channel.
  UsbCan(
    std::unique_ptr<flutter::MethodChannel<flutter::EncodableValue>> channel,
    std::unique_ptr<flutter::BasicMessageChannel<flutter::EncodableValue>> event_channel
      );

  virtual ~UsbCan();

  void onNewCanData(const std::vector<SignalData> signals);

 private:
  // Called when a method is called on |channel_|;
  void HandleMethodCall(
      const flutter::MethodCall<flutter::EncodableValue> &method_call,
      std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);

  // The MethodChannel used for communication with the Flutter engine.
  std::unique_ptr<flutter::MethodChannel<flutter::EncodableValue>> channel_;
  std::unique_ptr<flutter::BasicMessageChannel<flutter::EncodableValue>> event_channel_;
  std::unique_ptr<WeaponController> weapon_controller_;
};

// static
void UsbCan::RegisterWithRegistrar(flutter::PluginRegistrar *registrar) {

  std::cout << "UsbCan::RegisterWithRegistrar 111" << std::endl;
  auto channel =
      std::make_unique<flutter::MethodChannel<flutter::EncodableValue>>(
          registrar->messenger(), kChannelName,
          &flutter::StandardMethodCodec::GetInstance());
  auto *channel_pointer = channel.get();

  auto event_channel = std::make_unique<flutter::BasicMessageChannel<flutter::EncodableValue>>(
          registrar->messenger(), kEventChannelName,
                &flutter::StandardMessageCodec::GetInstance());
  std::cout << "UsbCan::RegisterWithRegistrar 222" << std::endl;
  auto plugin = std::make_unique<UsbCan>(std::move(channel), std::move(event_channel));
  std::cout << "UsbCan::RegisterWithRegistrar 333" << std::endl;

  channel_pointer->SetMethodCallHandler(
      [plugin_pointer = plugin.get()](const auto &call, auto result) {
        plugin_pointer->HandleMethodCall(call, std::move(result));
      });

  std::cout << "UsbCan::RegisterWithRegistrar 444" << std::endl;
  registrar->AddPlugin(std::move(plugin));

  std::cout << "UsbCan::RegisterWithRegistrar end" << std::endl;
}

UsbCan::UsbCan(
    std::unique_ptr<flutter::MethodChannel<flutter::EncodableValue>> channel,
    std::unique_ptr<flutter::BasicMessageChannel<flutter::EncodableValue>> event_channel
    )
    : channel_(std::move(channel)), event_channel_(std::move(event_channel)), weapon_controller_(std::make_unique<CanalystiiController>("canalystii", 500, std::bind(&UsbCan::onNewCanData, this, std::placeholders::_1)) ) {
}

UsbCan::~UsbCan(){};

static constexpr char kActionKey[] = "receive";
static constexpr char kNameKey[] = "name";
static constexpr char kSignalsKey[] = "signals";

void UsbCan::onNewCanData(const std::vector<SignalData> signals) {

  EncodableValue event(EncodableMap{
    {EncodableValue("name"), EncodableValue("receive")},
  });
  EncodableValue sArray = EncodableValue(EncodableList{});
  for(auto s : signals) {
    EncodableValue signal(EncodableMap{
      {EncodableValue("name"), EncodableValue(s.name)},
      {EncodableValue("value"), EncodableValue(s.value)},
      {EncodableValue("mid"), EncodableValue(s.mid)},
    });
    sArray.ListValue().push_back(signal);
  }
  event.MapValue()[EncodableValue("signals")] = sArray;

  event_channel_->Send(event);
}

void UsbCan::HandleMethodCall(
    const flutter::MethodCall<flutter::EncodableValue> &method_call,
    std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
    std::cout << "UsbCan::HandleMethodCall " << method_call.method_name() << std::endl;
    auto method = PluginInterfaceFactory::Create(method_call.method_name());
    if(!method) {
        result->NotImplemented();
    } else {
        method->excute(method_call, std::move(result), weapon_controller_.get());
    }
  // if (method_call.method_name().compare("getPlatformVersion") == 0) {
  //   struct utsname uname_data = {};
  //   uname(&uname_data);
  //   std::ostringstream version_stream;
  //   version_stream << "Linux " << uname_data.version;
  //   flutter::EncodableValue response(version_stream.str());
  //   result->Success(&response);
  // } else {
  //   result->NotImplemented();
  // }
}

}  // namespace plugins_usb_can

void UsbCanRegisterWithRegistrar(
    FlutterDesktopPluginRegistrarRef registrar) {
  // The plugin registrar owns the plugin, registered callbacks, etc., so must
  // remain valid for the life of the application.
  static auto *plugin_registrar = new flutter::PluginRegistrar(registrar);

  plugins_usb_can::UsbCan::RegisterWithRegistrar(plugin_registrar);
}
