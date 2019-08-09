#include "plugin_interface.h"

#include <flutter/standard_method_codec.h>
#include <iostream>
#include <utility>
#include <typeindex>
#include <type_traits>
#include <map>
#include <vector>
#include <algorithm> 


namespace plugins_usb_can {

void SyncMetaDatas::excute(
        const flutter::MethodCall<EncodableValue> &method_call,
        std::unique_ptr<flutter::MethodResult<EncodableValue>> result,
        WeaponController * weapon
        ) {

    if (!method_call.arguments() || !method_call.arguments()->IsList() || 
        method_call.arguments()->ListValue().size() != 1){
      result->Error("Bad arguments", "Expected 1 arguments");
      return;
    }

    std::map<uint32_t, std::shared_ptr<MessageMeta>> messages;
    std::map<std::string, std::shared_ptr<SignalMeta>> signals;
    std::map<std::string, std::shared_ptr<PartBuildStrategy>> strategies;

    auto param_m = method_call.arguments()->ListValue()[0].MapValue();

    auto e_messages = param_m[EncodableValue("messages")].ListValue();

    for (auto e_message : e_messages) {
        std::string name = e_message.MapValue()[EncodableValue("name")].StringValue();
        uint32_t id = e_message.MapValue()[EncodableValue("id")].IntValue();
        uint8_t dlc = e_message.MapValue()[EncodableValue("length")].IntValue();
        auto &e_signalValues = e_message.MapValue()[EncodableValue("signals")].ListValue();
        auto msg_tp = std::make_shared<MessageMeta>(MessageMeta { name, id, dlc, std::vector<std::string>()});
        for(auto e_signal: e_signalValues) {

            std::string s_name = e_signal.MapValue()[EncodableValue("name")].StringValue();
            uint32_t s_start = e_signal.MapValue()[EncodableValue("start_bit")].IntValue();
            uint32_t s_length = e_signal.MapValue()[EncodableValue("length")].IntValue();
            double s_scaling = e_signal.MapValue()[EncodableValue("scaling")].DoubleValue();
            double s_offset = e_signal.MapValue()[EncodableValue("offset")].DoubleValue();
            double s_minimum = e_signal.MapValue()[EncodableValue("minimum")].DoubleValue();
            double s_maximum = e_signal.MapValue()[EncodableValue("maximum")].DoubleValue();
            bool s_is_signed = e_signal.MapValue()[EncodableValue("is_signed")].IntValue() > 0;
            auto unit = e_signal.MapValue()[EncodableValue("unit")];
            std::string s_unit;
            if(unit.IsString()) {
                s_unit = unit.StringValue();
            } else {
                s_unit = "";
            }
            msg_tp->signal_names.push_back(s_name);

            signals[s_name] = std::make_shared<SignalMeta>(SignalMeta{ s_name, s_start, s_length, ByteOrder::kBigEndian, s_scaling, s_offset, s_minimum, s_maximum, s_is_signed, s_unit });
        }
        messages[id] = msg_tp;
    }
    weapon->SetMetaData(messages, signals);

    // for(auto e_strategy : param_s.ListValue()) {
    //     std::string name = e_strategy.MapValue()[EncodableValue("name")].StringValue();
    //     std::string type = e_strategy.MapValue()[EncodableValue("type")].StringValue();
    //
    //     std::shared_ptr<SignalMeta> signal_meta = signals.at(name);
    //     if(type == "const") {
    //         double value = e_strategy.MapValue()[EncodableValue("value")].DoubleValue();
    //         strategies[name] = std::move(BuildStrategyFactory::Create(type, signal_meta, value));
    //     } else {
    //         strategies[name] = std::move(BuildStrategyFactory::Create(type, signal_meta));
    //     }
    // }

    result->Success();
}

void Fire::excute(
        const flutter::MethodCall<EncodableValue> &method_call,
        std::unique_ptr<flutter::MethodResult<EncodableValue>> result,
        WeaponController * weapon
        ) {

    weapon->Fire();
    result->Success();
}

void CeaseFire::excute(
        const flutter::MethodCall<EncodableValue> &method_call,
        std::unique_ptr<flutter::MethodResult<EncodableValue>> result,
        WeaponController * weapon
        ) {

    weapon->CeaseFire();
    result->Success();
}

void LoadAmmo::excute(
        const flutter::MethodCall<EncodableValue> &method_call,
        std::unique_ptr<flutter::MethodResult<EncodableValue>> result,
        WeaponController * weapon
        ) {

    if (!method_call.arguments() || !method_call.arguments()->IsList() || 
        method_call.arguments()->ListValue().size() != 1){
      result->Error("Bad arguments", "Expected 1 arguments");
      return;
    }

    uint32_t mid = method_call.arguments()->ListValue()[0].IntValue();
    std::cout << "plugin_interface.cc LoadAmmo id is " << mid << std::endl;
    weapon->loadAmmo(mid);
    result->Success();
}

void UnloadAmmo::excute(
        const flutter::MethodCall<EncodableValue> &method_call,
        std::unique_ptr<flutter::MethodResult<EncodableValue>> result,
        WeaponController * weapon
        ) {

    if (!method_call.arguments() || !method_call.arguments()->IsList() || 
        method_call.arguments()->ListValue().size() != 1){
      result->Error("Bad arguments", "Expected 1 arguments");
      return;
    }

    uint32_t mid = method_call.arguments()->ListValue()[0].IntValue();

    weapon->unloadAmmo(mid);
    result->Success();
}

void SetStrategy::excute(
        const flutter::MethodCall<EncodableValue> &method_call,
        std::unique_ptr<flutter::MethodResult<EncodableValue>> result,
        WeaponController * weapon
        ) {

    if (!method_call.arguments() || !method_call.arguments()->IsList() || 
        method_call.arguments()->ListValue().size() != 2){
      result->Error("Bad arguments", "Expected 1 arguments");
      return;
    }

    std::string sname = method_call.arguments()->ListValue()[0].StringValue();
    double value = method_call.arguments()->ListValue()[1].DoubleValue();

    weapon->SetConstStrategy(sname, value);
    result->Success();
}

} //namespace plugins_usb_can 
