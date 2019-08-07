#include "usb_can_plugin.h"

#include <flutter/method_channel.h>
#include <flutter/plugin_registrar.h>
#include <flutter/standard_method_codec.h>
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
const char kChannelName[] = "flutter/usb_can";
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
      std::unique_ptr<WeaponController> weapon_controller
      );

  virtual ~UsbCan();

 private:
  // Called when a method is called on |channel_|;
  void HandleMethodCall(
      const flutter::MethodCall<flutter::EncodableValue> &method_call,
      std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);

  // The MethodChannel used for communication with the Flutter engine.
  std::unique_ptr<flutter::MethodChannel<flutter::EncodableValue>> channel_;
  std::unique_ptr<WeaponController> weapon_controller_;
};

// static
void UsbCan::RegisterWithRegistrar(flutter::PluginRegistrar *registrar) {

  std::cout << "UsbCan::RegisterWithRegistrar start" << std::endl;
  auto weapon_controller = std::make_unique<CanalystiiController>("canalystii", 500);
  std::cout << "UsbCan::RegisterWithRegistrar 111" << std::endl;
  auto channel =
      std::make_unique<flutter::MethodChannel<flutter::EncodableValue>>(
          registrar->messenger(), kChannelName,
          &flutter::StandardMethodCodec::GetInstance());
  auto *channel_pointer = channel.get();

  std::cout << "UsbCan::RegisterWithRegistrar 222" << std::endl;
  auto plugin = std::make_unique<UsbCan>(std::move(channel), std::move(weapon_controller));
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
    std::unique_ptr<WeaponController> weapon_controller
    )
    : channel_(std::move(channel)), weapon_controller_(std::move(weapon_controller)) {}

UsbCan::~UsbCan(){};

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
