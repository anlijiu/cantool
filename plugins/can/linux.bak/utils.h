#ifndef CAN_UTILS_H
#define CAN_UTILS_H

#include <bitset>
#include <memory>
#include "can_defs.h"

namespace plugins_usb_can {

std::string currentDateAndTime();

void
printBits(size_t const size, void const *const ptr);

template <size_t max>
std::bitset<max> reverse(std::bitset<max> const &bset)
{
  std::bitset<max> reverse;
  for (size_t iter = 0; iter < max; ++iter)
  {
    reverse[iter] = bset[max - iter - 1];
  }
  return reverse;
}

} //namespace plugins_usb_can

#endif /* CAN_UTILS_H */
