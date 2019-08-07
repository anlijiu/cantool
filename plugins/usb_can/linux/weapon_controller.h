#ifndef WEAPON_CONTROLLER_H
#define WEAPON_CONTROLLER_H

#include <vector>
#include <sstream>
#include <string>
#include <map>
#include <functional>
#include <condition_variable>
//#include <thread>
#include "ammo/ammo.h"
#include "ammo/ammo_generator.h"
#include "timer.h"
#include "can_defs.h"
#include "canalystii.h"

#include "property.h"

namespace plugins_usb_can {

class WeaponController {
public:
  WeaponController() = default;
  WeaponController(std::string const& name);
  virtual ~WeaponController();

  virtual void Fire();

  virtual void CeaseFire();

  void test();
  void InitializeReceiver();
  bool IsReceiving();
  void UnInitializeReceiver();


  std::string& Name();

  void SetMetaData(std::map<uint32_t, std::shared_ptr<MessageMeta>> const&,
                std::map<std::string, std::shared_ptr<SignalMeta>> const&);

  void SetStrategy(std::string signal_name, std::shared_ptr<PartBuildStrategy> strategy);
  void SetConstStrategy(std::string signal_name, double value);

  void loadAmmo(std::vector<uint32_t> msg_ids);
  void loadAmmo(uint32_t msg_id);
  void unloadAmmo(uint32_t msg_id);

  virtual int AddRadarListener(std::function<void(const can_frame&)> const& listener) {
    return frame_property_.on_change().connect(listener);
  };

  virtual void RemoveRadarListener(int id) {
    frame_property_.on_change().disconnect(id);
  }

  const std::map<std::string, std::shared_ptr<SignalMeta>>& Signals() {
    return mp_signal_meta_;
  };

  std::pair<std::vector<Message>,  std::vector<Message>> AcquireReceiveData();

protected:
  virtual std::tuple<bool, int> Shoot(Ammo const& ammo) = 0;
  virtual std::tuple<bool, int> Shoot(std::vector<Ammo> const& ammos) = 0;

  void StartReceive();
  void StopReceive();
  virtual void onStartReceive() = 0;
  virtual void onStopReceive() = 0;

  void OnReceiveMessages(std::vector<Message> & messages);

  bool is_receiving_ = false;
  bool is_device_ready = false;
  bool is_receive_t_freeze_ = true;
  std::condition_variable receive_cv_;
  std::mutex receive_mtx;
  std::thread receive_t_;
private:

  std::map<uint32_t, std::shared_ptr<MessageMeta>> mp_message_meta_;
  std::map<std::string, std::shared_ptr<SignalMeta>> mp_signal_meta_;
  std::map<std::string, std::shared_ptr<PartBuildStrategy>> mp_strategies_;
  std::vector<uint32_t> loaded_ammos_;
  std::stringstream stringstream_;

  Property<can_frame> frame_property_;//TODO
  std::string name_;
  Timer timer_;
  std::vector<std::unique_ptr<AmmoGenerator>> ammo_generators_;
  bool firing_ = false;

  std::map<uint32_t, Message> recv_messages;

  void Auto_(void);
};

class CanalystiiController : public WeaponController {
public:
  CanalystiiController();
  explicit CanalystiiController( std::string const& name, int rate);
  int Initialize();

  bool Release();

protected:
  std::tuple<bool, int> Shoot(Ammo const& ammo) override ;
  std::tuple<bool, int> Shoot(std::vector<Ammo> const& ammos) override;
  void onStartReceive() override;
  void onStopReceive() override;
private:


  CANalystii can_node_;
  std::thread receiver_t_;
  int rate_;
};

} //namespace plugins_usb_can


#endif /* WEAPON_CONTROLLER_H */
