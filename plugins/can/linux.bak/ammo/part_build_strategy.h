#ifndef CAN_PART_BUILD_STRATEGY_H
#define CAN_PART_BUILD_STRATEGY_H

#include <bitset>
#include "can_defs.h"
#include "build_strategy_type.h"
#include "factory_prototype.h"

namespace plugins_usb_can {

class PartBuildStrategy {
public:

  explicit PartBuildStrategy(std::shared_ptr<SignalMeta> signal_meta): signal_meta_(signal_meta) {}

  virtual ~PartBuildStrategy() {}

  virtual int Generate(uint8_t * dest) = 0;

  virtual BuildStrategyType Type() = 0;

  std::string Name() { return signal_meta_->name; }

  std::shared_ptr<SignalMeta> GetSignalMeta() { return signal_meta_; }


private:
  std::shared_ptr<SignalMeta> signal_meta_;
};

using BuildStrategyFactory = FactoryPrototype<std::string, PartBuildStrategy>;

} // namespace plugins_usb_can

#endif //CAN_PART_BUILD_STRATEGY_H
