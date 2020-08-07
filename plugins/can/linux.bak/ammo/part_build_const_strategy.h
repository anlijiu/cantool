//
// Created by anlijiu on 18-1-19.
//
#ifndef CANALYST_SIGNAL_BUILDER_CONST_STRATEGY_H
#define CANALYST_SIGNAL_BUILDER_CONST_STRATEGY_H

#include "ammo/part_build_strategy.h"
#include "build_strategy_type.h"

namespace plugins_usb_can {

class PartBuildConstStrategy : public PartBuildStrategy {
  /* 参数顺序依次为信号名, value */
  using StrategyRegister = BuildStrategyFactory::FactoryPrototypeRegister<PartBuildConstStrategy, std::shared_ptr<SignalMeta> , double>;
public:
  PartBuildConstStrategy(std::shared_ptr<SignalMeta>, double);

  BuildStrategyType Type() override;
  void SetValue(double value);

  int Generate(uint8_t * dest) override ;
private:
  // std::shared_ptr<SignalMeta> signal_meta_ = nullptr;
  double value_ = 0;
  const BuildStrategyType type_ = kConst;
  inline const static StrategyRegister reg{ std::string("const") };

};


} //namespace plugins_usb_can
#endif //CANALYST_SIGNAL_BUILDER_CONST_STRATEGY_H
