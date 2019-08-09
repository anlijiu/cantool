
#ifndef SIGNAL_STORE_H
#define SIGNAL_STORE_H


#include <string>
#include <map>
#include <mutex>

namespace plugins_usb_can {

class SignalStore {

public:
    SignalStore();

    bool writeValue(std::string, double);
    bool equel(double, double);

private:

    using MuxGuard = std::lock_guard<std::mutex>;
    mutable std::mutex mLock;

    using SignalMap = std::map<std::string, double>;
    SignalMap mSignalMap;
};


} //namespace plugins_usb_can
#endif /* SIGNAL_STORE_H */
