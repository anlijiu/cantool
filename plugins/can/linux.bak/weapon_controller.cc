#include <vector>
#include <iomanip>
#include <iostream>

#include "weapon_controller.h"
#include "enumerate.h"
#include "libwecan.h"
#include "property.h"
#include "utils.h"
#include "date/tz.h"
#include "date/date.h"

using std::cout;

namespace plugins_usb_can {

WeaponController::WeaponController(std::string const &name,  const ReceiveAction& action) : name_(name),
    store(new SignalStore()),
    mReceiveAction(action),
    frame_property_({}),
    timer_(std::bind(&WeaponController::Auto_, this))
{
  timer_.SetSingleShot(false);
  timer_.SetInterval(Timer::Interval(10));
  InitializeReceiver();
}

WeaponController::~WeaponController()
{
  timer_.Stop();
  UnInitializeReceiver();
  delete store;
}

std::string &
WeaponController::Name()
{
  return name_;
}

void
WeaponController::Fire()
{
  timer_.Start(true);
  firing_ = true;
}

void
WeaponController::CeaseFire()
{
  timer_.Stop();
  firing_ = false;
}

// void WeaponController::processReceiveThread() {
//   while(IsReceiving()) {
//     std::this_thread::sleep_for (std::chrono::milliseconds(50));
//     processReceiveData();
//   }
// }

void WeaponController::processReceiveData(const std::vector<Message>& messages) {
  if(messages.empty()) return;

  std::vector<SignalData> sArray;
  for(auto& p : messages) {
    auto iter = mp_message_meta_.find(p.id);
    if(iter != mp_message_meta_.end()) {
      for(std::string signal_name : iter->second->signal_names) {
        SignalData d;
        d.name = signal_name;
        auto s_iter = mp_signal_meta_.find(signal_name);
        if(s_iter != mp_signal_meta_.end()) {
          std::shared_ptr<SignalMeta> signal_meta = s_iter->second;
          uint64_t origvalue = extract(reinterpret_cast<const uint8_t*>(p.raw), signal_meta->start_bit, signal_meta->length, UNSIGNED, MOTOROLA);
          double signal_value = origvalue * signal_meta->scaling;
          d.value = signal_value;
          d.mid = p.id;
          if(store->writeValue(d.name, d.value)) {
            sArray.push_back(d);
          }
        }
      }
    }
  }
  if(sArray.empty()) return;
  mReceiveAction(sArray);
}

std::pair< std::vector<Message>,  std::vector<Message>>
WeaponController::AcquireReceiveData()
{
  std::vector<Message> known;
  std::vector<Message> unknown;
  // receive_mtx.lock();
  for(auto& p : recv_messages) {
    stringstream_.clear();
    stringstream_.str("");
    for(int i = 0; i < p.second.dlc; ++i) {
      stringstream_ << std::hex << std::setfill('0') << std::setw(2) << static_cast<int>(p.second.raw[i]) << " ";
    }
    p.second.data = stringstream_.str();

    auto iter = mp_message_meta_.find(p.first);

    if(iter != mp_message_meta_.end()) {
      p.second.name = iter->second->name;
      for(std::string signal_name : iter->second->signal_names) {
        std::shared_ptr<SignalMeta> signal_meta = mp_signal_meta_.at(signal_name);
        uint64_t origvalue = extract(reinterpret_cast<const uint8_t*>(p.second.raw), signal_meta->start_bit, signal_meta->length, UNSIGNED, MOTOROLA);
        double signal_value = origvalue * signal_meta->scaling;
        p.second.signals.push_back(Signal{signal_name, signal_value});
      }
      std::cout << " know " << p.second.name << " id " << p.second.id << "\n";
      known.push_back(p.second);
    } else {
      unknown.push_back(p.second);
    }

  }
  recv_messages.clear();

  // receive_mtx.unlock();

  return std::make_pair(known, unknown);
};

void
WeaponController::InitializeReceiver() {
  if(!is_receiving_) {
    is_receiving_ = true;
    receive_t_ = std::thread(
            &WeaponController::StartReceive, this);
    // receive_process_t_ = std::thread(
    //         &WeaponController::processReceiveThread, this);
            // &WeaponController::test, this);
  }
}

void WeaponController::StartReceive() {
    std::this_thread::sleep_for (std::chrono::milliseconds(50));
    onStartReceive();
}

void WeaponController::StopReceive() {
    onStopReceive();
}

void WeaponController::test() {
    while(1) {
        std::cout<<"WeaponController::test" << std::endl;
        std::this_thread::sleep_for (std::chrono::milliseconds(1000));
    }
}

bool WeaponController::IsReceiving() {
  return is_receiving_;
}

void
WeaponController::UnInitializeReceiver() {
  is_receiving_ = false;
  receive_t_.detach();
  receive_process_t_.detach();
}

void
WeaponController::OnReceiveMessages(std::vector<Message> & messages)
{
  if(messages.empty()) return;
  
  for (auto& c : messages) {
    // std::cout << " messge id:" << c.id << " data:" << c.raw << "\n";
    recv_messages.emplace(c.id, c);
  }
}

void
WeaponController::SetMetaData(std::map<uint32_t, std::shared_ptr<MessageMeta>> const& mp_message_meta,
                 std::map<std::string, std::shared_ptr<SignalMeta>> const& mp_signal_meta)
{
  for (auto c : mp_message_meta) {
    mp_message_meta_.emplace(c.first, c.second);
  }

  for (auto c : mp_signal_meta) {
    mp_signal_meta_.emplace(c.first, c.second);

    std::shared_ptr<PartBuildStrategy> build_strategy = std::move(BuildStrategyFactory::Create("const", c.second, c.second->minimum));
    mp_strategies_[c.second->name] = build_strategy;
  }

  // for (auto c : mp_strategies) {
  //   mp_strategies_.emplace(c.first, c.second);
  // }
}

void
WeaponController::loadAmmo(std::vector<uint32_t> msg_ids)
{
  for(uint32_t msg_id : msg_ids) {
    loadAmmo(msg_id);
  }
}

void
WeaponController::loadAmmo(uint32_t msg_id)
{
  std::cout << "WeaponController::loadAmmo id is " << msg_id << std::endl;
  std::cout << "loadAmmo 000 id is " << msg_id << " mp_message_meta_ size is " << mp_message_meta_.size() << std::endl;
  for(auto msgmeta : mp_message_meta_) {
    std::cout << msgmeta.first << ": " << msgmeta.second << "\n";
  }
  std::shared_ptr<MessageMeta> message_meta;
  try {
    message_meta = mp_message_meta_.at(msg_id);
  } catch (std::out_of_range ex) {
    std::cout << "WeaponController::loadAmmo can't find msg_id " << msg_id << std::endl;
  }
  std:cout << "message's signals size is " << message_meta->signal_names.size() << "strategy size is " << mp_strategies_.size() << std::endl;
  std::vector<AmmoPartGenerator> part_generators;
  for(std::string signal_name : message_meta->signal_names) {
    std::shared_ptr<PartBuildStrategy> build_strategy;
    std::cout << "111" << std::endl;
    try {
      std::cout << "222" << std::endl;
      build_strategy = mp_strategies_.at(signal_name);
      std::cout << "333" << std::endl;
    } catch(std::out_of_range ex) {
      std::cout << "WeaponController::loadAmmo can't find strategy " << signal_name << std::endl;
      std::shared_ptr<SignalMeta> sMeta = mp_signal_meta_.at(signal_name);
      build_strategy = std::move(BuildStrategyFactory::Create("const", sMeta, sMeta->minimum));
      mp_strategies_[signal_name] = build_strategy;

      std::cout << "444" << std::endl;
    }
    std::cout << "loadAmmo 3" << "\n";
    part_generators.emplace_back(AmmoPartGenerator(build_strategy));
  }
  std::unique_ptr<AmmoGenerator> generator = std::make_unique<AmmoGenerator>(message_meta, part_generators);
  ammo_generators_.emplace_back(std::move(generator));
}

void
WeaponController::unloadAmmo(uint32_t msg_id)
{
  std::vector<std::unique_ptr<AmmoGenerator>>::iterator it =
          std::find_if(ammo_generators_.begin(), ammo_generators_.end(),
                       [&](std::unique_ptr<AmmoGenerator> & obj){ return obj->MsgId() == msg_id;});

  if(it != ammo_generators_.end()) {
    ammo_generators_.erase(it);
  }

}

void
WeaponController::SetStrategy(std::string signal_name,
                              std::shared_ptr<PartBuildStrategy> strategy)
{
  uint32_t msg_id = 0;
  auto msg_iterator = std::find_if(std::begin(mp_message_meta_),
                         std::end(mp_message_meta_),
                         [signal_name] (std::pair<uint32_t, std::shared_ptr<MessageMeta>> const& entry)
                         {
                           std::vector<std::string> v = entry.second->signal_names;
                           return std::find(v.begin(), v.end(), signal_name) != v.end();
                         });

  if (msg_iterator != std::end(mp_message_meta_)) {
    std::cout << "WeaponController::SetStrategy   find msg_id !!!!  -> " << msg_iterator->first << "\n";
    msg_id = msg_iterator->first;
  } else {
    std::cout << "WeaponController::SetStrategy  错误 error !!!!!!!!!!!!!!!!!!, didn't find msg_id" << "\n";
    return;
  }

  mp_strategies_[signal_name] = strategy;

  std::vector<std::unique_ptr<AmmoGenerator>>::iterator it =
          std::find_if(ammo_generators_.begin(), ammo_generators_.end(),
                       [&](std::unique_ptr<AmmoGenerator> & obj){ return obj->MsgId() == msg_id;});

  if (it != ammo_generators_.end())
  {
    (*it)->SetStrategy(signal_name, strategy);
  }
}

void WeaponController::SetConstStrategy(std::string signal_name, double value) {
  std::shared_ptr<SignalMeta> sMeta = mp_signal_meta_.at(signal_name);
  std::shared_ptr<PartBuildStrategy> build_strategy = std::move(BuildStrategyFactory::Create("const", sMeta, value));
  SetStrategy(signal_name, build_strategy);
}

void
WeaponController::Auto_() {
  std::vector<Ammo> ammos;
  for(auto& e : ammo_generators_) {
    ammos.emplace_back(e->Generate());
  }
  Shoot(ammos);
//  Shoot(ammo_generators_.Generate());
}

CanalystiiController::CanalystiiController(std::string const &name, int rate, const ReceiveAction& action)
        : WeaponController(name, action), rate_(rate)
{
  this->Initialize();
}


int CanalystiiController::Initialize() {

  if (!can_node_.start_device()) {
    cout << "canalystii device starts error";
    return -1;
  }

  VCI_INIT_CONFIG vci_conf;
  vci_conf.AccCode = 0x80000008;
  vci_conf.AccMask = 0xFFFFFFFF;
  vci_conf.Filter = 1;//receive all frames
  vci_conf.Timing0 = 0x00;
  vci_conf.Timing1 = 0x1C;//baudrate 500kbps
  vci_conf.Mode = 0;//normal mode
  unsigned int can_idx = 0;
  if (!can_node_.init_can_interface(can_idx, vci_conf)) {
    cout << "device port init error";
    is_device_ready = false;
    return -1;
  }
  is_device_ready = true;
  cout << "device port init success!!!!!";
  return 1;
}


void
CanalystiiController::onStartReceive()
{
    std::cout<<__func__ <<std::endl;
  VCI_CAN_OBJ can_obj[100];
  unsigned int recv_len = 100;
  unsigned int can_idx = 0;
  //int len = can_node.receive_can_frame(can_idx,can_obj,recv_len,0);
  unsigned int receive_len = 0;
  while(IsReceiving()) {

    memset(&can_obj, 0, sizeof can_obj);
    if(is_device_ready && (receive_len = can_node_.receive_can_frame(can_idx,can_obj,recv_len,20)) > 0) {
      // cout << "CanalystiiController::onStartReceive  received " << receive_len << " entries message." << std::endl;
      if(!IsReceiving()) return;
      if(!IsReceiving()) return;
      std::vector<Message> messages;
    //   auto zonedTime = date::make_zoned(date::current_zone(),
    //                               std::chrono::system_clock::now());
    //   std::stringstream stringstream;
      // stringstream << zonedTime;
      for(int i = 0; i < receive_len; ++i) {
        if(can_obj[i].ID == 0) continue;

        Message message {
                (uint32_t)can_obj[i].ID,
                (uint8_t)can_obj[i].DataLen,
        };
        std::memcpy(message.raw, can_obj[i].Data, 8);
        messages.push_back(message);
      }
      // receive_mtx.lock();
      processReceiveData(messages);
      // receive_mtx.unlock();

//      OnReceiveMessage(can_obj);
      //ROS_INFO("received:%u",can_obj.ID);
      // canalystii_node_msg::can msg = CANalystii_node::can_obj2msg(can_obj);
      // can_node.can_msg_pub_.publish(msg);
    }
    std::this_thread::sleep_for (std::chrono::milliseconds(50));
    //ros::spinOnce();
  }
}

void
CanalystiiController::onStopReceive()
{

}

std::tuple<bool, int>
CanalystiiController::Shoot(Ammo const& ammo)
{
  std::tuple<bool, int> result;

  VCI_CAN_OBJ canObj;
  canObj.ID = ammo.id;
  canObj.ExternFlag = 0;   /*CAN_INIT_TYPE_ST*/
  canObj.RemoteFlag = 0;
  canObj.DataLen = ammo.dlc;

  std::memcpy(canObj.Data, &ammo.data, ammo.dlc);

  bool status = can_node_.send_can_frame(0, &canObj, 1);
  result = std::make_tuple(status, 0);
  std::cout << "shoot id:"<<ammo.id << " result is " << status << " data is ";
  printBits(ammo.dlc, canObj.Data);
  return result;
}

std::tuple<bool, int>
CanalystiiController::Shoot(std::vector<Ammo> const& ammos)
{
  std::tuple<bool, int> result;

  VCI_CAN_OBJ canObjs[ammos.size()];
  for(auto e : enumerate(ammos))
  {
    canObjs[e.first].ID = e.second.id;

    canObjs[e.first].ExternFlag = 0;   /*CAN_INIT_TYPE_ST*/
    canObjs[e.first].RemoteFlag = 0;
    canObjs[e.first].DataLen = e.second.dlc;

    std::memcpy(canObjs[e.first].Data, &e.second.data, e.second.dlc);
  }

  bool status = can_node_.send_can_frame(0, canObjs, ammos.size());
  std::cout << "CanalystiiController::Shoot" << status << std::endl;

  result = std::make_tuple(status, 0);

  return result;

};

bool CanalystiiController::Release() {
  can_node_.close_device();
  return true;
}

} //namespace plugins_usb_can
