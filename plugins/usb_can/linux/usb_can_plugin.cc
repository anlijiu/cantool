#include "usb_can_plugin.h"

#include <sys/utsname.h>
#include <memory>
#include <sstream>
#include <flutter/method_channel.h>
#include <flutter/basic_message_channel.h>
#include <flutter/binary_messenger.h>
#include <flutter/plugin_registrar.h>
#include <flutter/standard_method_codec.h>
#include <flutter/standard_message_codec.h>
#include "plugin_interface.h"
#include "weapon_controller.h"

namespace plugins_usb_can {

namespace {

using flutter::EncodableList;
using flutter::EncodableMap;
using flutter::EncodableValue;

// See channel_controller.dart for documentation.
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
