#include <cstdio>
#include <cstdint>
#include <cassert>
#include <iostream>
#include <chrono>
#include <string>
#include <sstream>
#include <iomanip>
#include "utils.h"

namespace plugins_usb_can {

std::string currentDateAndTime()
{
    auto now = std::chrono::system_clock::now();
    auto in_time_t = std::chrono::system_clock::to_time_t(now);

    std::stringstream ss;
    ss << std::put_time(std::localtime(&in_time_t), "%Y-%m-%d %X %f");
    return ss.str();
}

//assumes little endian
void printBits(size_t const size, void const *const ptr) {
  unsigned char *b = (unsigned char *) ptr;
  unsigned char byte;
  int i, j;
  for (i = 0; i <= size - 1; ++i) {
    for (j = 0; j <= 7; ++j) {
      byte = (b[i] >> j) & 1;
      printf("%u", byte);
    }
    printf(" ");
  }

  printf("\n");
}

} //namespace plugins_usb_can
