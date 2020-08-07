#ifndef PLUGINS_CAN_PLUGIN_INTERFACE_H
#define PLUGINS_CAN_PLUGIN_INTERFACE_H

#include <memory>

#include <flutter/standard_method_codec.h>
#include <flutter/method_result.h>
#include "enumerate.h"
#include "can_defs.h"
#include "factory_prototype.h"
#include "ammo/part_build_strategy.h"
#include "weapon_controller.h"

namespace plugins_usb_can {

using flutter::EncodableList;
using flutter::EncodableMap;
using flutter::EncodableValue;


const char kSyncMetaDatas[] = "UsbCan.SyncMetaDatas";
const char kFire[] = "UsbCan.Fire";
const char kCeaseFire[] = "UsbCan.CeaseFire";
const char kLoadAmmo[] = "UsbCan.LoadAmmo";
const char kUnloadAmmo[] = "UsbCan.UnloadAmmo";
const char kSetConstStrategy[] = "UsbCan.SetConstStrategy";

class PluginInterface {
public: 
    virtual ~PluginInterface() {}
    virtual void excute(
            const flutter::MethodCall<EncodableValue> &method_call,
            std::unique_ptr<flutter::MethodResult<EncodableValue>> result,
            WeaponController * weapon
            ) = 0;
};

using PluginInterfaceFactory = FactoryPrototype<std::string, PluginInterface>;

class SyncMetaDatas : public PluginInterface {
  using SyncMetaDatasRegister = PluginInterfaceFactory::FactoryPrototypeRegister<SyncMetaDatas>;
public:
    virtual ~SyncMetaDatas() {}
    void excute(
            const flutter::MethodCall<EncodableValue> &method_call,
            std::unique_ptr<flutter::MethodResult<EncodableValue>> result,
            WeaponController * weapon
            ) override;
private:
  inline const static SyncMetaDatasRegister reg{ std::string(kSyncMetaDatas) };
};

class Fire : public PluginInterface {
  using FireRegister = PluginInterfaceFactory::FactoryPrototypeRegister<Fire>;
public:
    virtual ~Fire() {}
    void excute(
            const flutter::MethodCall<EncodableValue> &method_call,
            std::unique_ptr<flutter::MethodResult<EncodableValue>> result,
            WeaponController * weapon
            ) override;
private:
  inline const static FireRegister reg{ std::string(kFire) };
};

class CeaseFire : public PluginInterface {
  using CeaseFireRegister = PluginInterfaceFactory::FactoryPrototypeRegister<CeaseFire>;
public:
    virtual ~CeaseFire() {}
    void excute(
            const flutter::MethodCall<EncodableValue> &method_call,
            std::unique_ptr<flutter::MethodResult<EncodableValue>> result,
            WeaponController * weapon
            ) override;
private:
  inline const static CeaseFireRegister reg{ std::string(kCeaseFire) };
};

class LoadAmmo: public PluginInterface {
  using LoadAmmoRegister = PluginInterfaceFactory::FactoryPrototypeRegister<LoadAmmo>;
public:
    virtual ~LoadAmmo() {}
    void excute(
            const flutter::MethodCall<EncodableValue> &method_call,
            std::unique_ptr<flutter::MethodResult<EncodableValue>> result,
            WeaponController * weapon
            ) override;
private:
  inline const static LoadAmmoRegister reg{ std::string(kLoadAmmo) };
};

class UnloadAmmo: public PluginInterface {
  using UnloadAmmoRegister = PluginInterfaceFactory::FactoryPrototypeRegister<UnloadAmmo>;
public:
    virtual ~UnloadAmmo() {}
    void excute(
            const flutter::MethodCall<EncodableValue> &method_call,
            std::unique_ptr<flutter::MethodResult<EncodableValue>> result,
            WeaponController * weapon
            ) override;
private:
  inline const static UnloadAmmoRegister reg{ std::string(kUnloadAmmo) };
};

class SetStrategy: public PluginInterface {
  using SetStrategyRegister = PluginInterfaceFactory::FactoryPrototypeRegister<SetStrategy>;
public:
    virtual ~SetStrategy() {}
    void excute(
            const flutter::MethodCall<EncodableValue> &method_call,
            std::unique_ptr<flutter::MethodResult<EncodableValue>> result,
            WeaponController * weapon
            ) override;
private:
  inline const static SetStrategyRegister reg{ std::string(kSetConstStrategy) };
};
} //namespace plugins_usb_can
#endif // PLUGINS_CAN_PLUGIN_INTERFACE_H
