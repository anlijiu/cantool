//
// Created by anlijiu on 18-1-19.
//
#ifndef CANALYST_SIGNAL_BUILDER_SIN_STRATEGY_H
#define CANALYST_SIGNAL_BUILDER_SIN_STRATEGY_H

#include "ammo/part_build_strategy.h"
#include "build_strategy_type.h"

namespace plugins_usb_can {

class PartBuildSinStrategy : public PartBuildStrategy {
  /* 参数顺序为信号名 */
  using StrategyRegister = BuildStrategyFactory::FactoryPrototypeRegister<PartBuildSinStrategy, std::shared_ptr<SignalMeta> >;
public:
  PartBuildSinStrategy(std::shared_ptr<SignalMeta>);

  BuildStrategyType Type() override;

  int Generate(uint8_t * dest) override ;
private:
  // std::shared_ptr<SignalMeta> signal_meta_ = nullptr;
  double degree = 0;
  const BuildStrategyType type_ = kSin;
  inline const static StrategyRegister reg{ std::string("sin") };

};


} //namespace plugins_usb_can
#endif //CANALYST_SIGNAL_BUILDER_SIN_STRATEGY_H
