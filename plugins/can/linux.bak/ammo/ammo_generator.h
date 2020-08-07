#ifndef CAN_AMMO_GENERATOR_H
#define CAN_AMMO_GENERATOR_H

#include <map>

#include "can_defs.h"
#include "ammo_part_generator.h"
#include "ammo.h"

namespace plugins_usb_can {

/**
 * 生成对应 message 的数据帧作为弹药发射到CAN总线
 * 生成规则为所有 AmmoPartBuilder 生成的part组合而成
 */
class AmmoGenerator {
public:
  AmmoGenerator(std::shared_ptr<MessageMeta>, std::vector<AmmoPartGenerator> const&);
  Ammo Generate();
  uint32_t MsgId();
  void SetStrategy(std::string signal_name, std::shared_ptr<PartBuildStrategy> strategy);

private:
    std::shared_ptr<MessageMeta> message_meta_;
    std::vector<AmmoPartGenerator> generators_;
};


} //namespace plugins_usb_can

#endif //CAN_AMMO_GENERATOR_H
