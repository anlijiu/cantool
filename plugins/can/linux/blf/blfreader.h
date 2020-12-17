#ifndef INCLUDE_BLFREADER_H
#define INCLUDE_BLFREADER_H

/*  blfreader.h --  declarations for blfReader
    Copyright (C) 2016-2017 Andreas Heitmann

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>. */

#include <inttypes.h>
#include <stdint.h>

#include <stdio.h>
#include <candbc-types.h>
#include <flutter_linux/flutter_linux.h>
#include <stdbool.h>
#include "blfapi.h"
#include <replay_operator.h>


/* CAN message type */
typedef struct {
  struct {
    time_t tv_sec;
    uint32_t tv_nsec;
  } t;                    /* time stamp */
  uint16_t  bus;          /* can bus */
  uint32_t  id;           /* numeric CAN-ID */
  double    time;
  uint8_t   dlc;          /* number of bytes */
  uint8_t   byte_arr[64]; /* 64 bytes for CAN-FD messages */
} canMessage_t;


#ifdef __cplusplus
extern "C" {
#endif


// bool parse_blf(const char *path, FlValue* filter, FlValue* result);
bool parse_blf(const char *path, filter_repo_map* filter, can_trace_cb cb);

#ifdef __cplusplus
}
#endif

#endif
