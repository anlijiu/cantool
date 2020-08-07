#include "signal_store.h"

namespace plugins_usb_can {


SignalStore::SignalStore() {}

bool SignalStore::equel(double num1, double num2) {
  if( (num1-num2>-0.00001) && (num1-num2)<0.00001 ) return true;
  return false;
}


bool SignalStore::writeValue(std::string name, double value) {
    MuxGuard g(mLock);
    auto it = mSignalMap.find(name);
    if(it == mSignalMap.end() || !equel(it->second, value)) {
        mSignalMap[name] = value;
        return true;
    }
    return false;
}


}//namespace plugins_usb_can
