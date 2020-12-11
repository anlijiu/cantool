/*  blfReader.c -- parse BLF files
    Copyright (C) 2016-2020 Andreas Heitmann

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


#include <stdio.h>
#include <string.h>
#include <inttypes.h>
#include <assert.h>
#include <flutter_linux/flutter_linux.h>

#include "blfreader.h"
#include "blfapi.h"

#include "list.h"
#include "hashmap.h"
#include "dbc_parser.h"
#include "can_defs.h"
#include "libwecan.h"
#include "log.h"

struct message {
    uint32_t id;
    list_t * signal_ids = NULL;
};

typedef HASHMAP(uint32_t, struct message) FilterRepoMap;

typedef struct CBData {
    FilterRepoMap *filterMap;
    FlValue * result;
} CBData;


static void
blfSystemTimePrint(SYSTEMTIME *const s)
{
  const char *dow[] = {
      "Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"
  };
  debug_info("%s %04d-%02d-%02d %02d:%02d:%02d.%03d",
   (s->wDayOfWeek < 7) ? dow[s->wDayOfWeek < 7 ]: "???",
   s->wYear,
   s->wMonth,
   s->wDay,
   s->wHour,
   s->wMinute,
   s->wSecond,
   s->wMilliseconds);
}

static void
blfCANMessageDump(const canMessage_t* canMessage)
{
  uint8_t i;

  printf("MSG %ld.%09" PRIu32 ": %d 0x%04x %d [ ",
          canMessage->t.tv_sec,
          canMessage->t.tv_nsec,
          canMessage->bus,
          canMessage->id,
          canMessage->dlc);
  for(i = 0; i < canMessage->dlc; i++) {
    printf("%02x ", canMessage->byte_arr[i]);
  }
  puts("]");
}

static void
blfVBLCANMessageParseTime(const VBLObjectHeader* header, time_t *sec,
                          uint32_t *nsec, double *time)
{
  const uint64_t C_1E9  = 1000000000ULL;
  const uint64_t C_1E5  =     100000ULL;
  const uint64_t C_1E4  =      10000ULL;
  const uint32_t flags = header->mObjectFlags;
  
  if (flags & BL_OBJ_FLAG_TIME_TEN_MICS) {
    /* 10 microsecond increments */
    *sec   = header->mObjectTimeStamp / C_1E5;
    *nsec = (header->mObjectTimeStamp % C_1E5) * C_1E4;
    *time = header->mObjectTimeStamp / 100;
  } else if (flags & BL_OBJ_FLAG_TIME_ONE_NANS) {
    /* 1 nanosecond increments */
    *sec  = header->mObjectTimeStamp / C_1E9;
    *nsec = header->mObjectTimeStamp % C_1E9;
    *time = header->mObjectTimeStamp / 1000000;
  } else { /* unknown time format - emit zero time stamp */
    *sec = 0;
    *nsec = 0;
    *time = 0.0;
  }
}

void testprint(canMessage_t *message, void *cbData) {
    CBData* cbd = (CBData*)cbData;
    FilterRepoMap * filterMap = cbd->filterMap;
    FlValue* result = cbd->result;
    FlValue* data = fl_value_lookup_string(result, "data");

    struct message* m = hashmap_get(filterMap, &(message->id));
    if(m == NULL) return;

    list_iterator_t *it = list_iterator_new(m->signal_ids, LIST_HEAD);
    list_node_t *nt = NULL;
    while((nt = list_iterator_next(it)) != NULL ) { 
        struct signal_meta * s_meta = get_signal_meta_by_id((const char *)nt->val);
        // debug_info("processcontent s_meta name is %s\n ", s_meta->name);
        if(s_meta == NULL) continue;
        FlValue *signal_list = fl_value_lookup_string(data, (const char *)nt->val);
        if(signal_list == NULL) {
            signal_list = fl_value_new_list();
            fl_value_set_string_take(data, (const char *)nt->val, signal_list);
        }

        uint64_t origvalue = extract(message->byte_arr, s_meta->start_bit, s_meta->length, UNSIGNED, MOTOROLA);
        double signal_value = origvalue * s_meta->scaling;
        
        FlValue* fv_signal = fl_value_new_map();
        fl_value_set_string_take(fv_signal, "value", fl_value_new_float(signal_value));
        fl_value_set_string_take(fv_signal, "time", fl_value_new_float(message->time));
        fl_value_append_take(signal_list, fv_signal);
    }   
    list_iterator_destroy(it);
}

void testtime(SYSTEMTIME *s, SYSTEMTIME *e, void *cbData) {

    CBData* cbd = (CBData*)cbData;
    FlValue* result = cbd->result;

    FlValue* summary = fl_value_lookup_string(result, "summary");

    FlValue* datetime = fl_value_new_map();
    fl_value_set_string_take(datetime, "year", fl_value_new_int(s->wYear));
    fl_value_set_string_take(datetime, "month", fl_value_new_int(s->wMonth));
    fl_value_set_string_take(datetime, "day", fl_value_new_int(s->wDay));
    fl_value_set_string_take(datetime, "hour", fl_value_new_int(s->wHour));
    fl_value_set_string_take(datetime, "minute", fl_value_new_int(s->wMinute));
    fl_value_set_string_take(datetime, "second", fl_value_new_int(s->wSecond));
    fl_value_set_string_take(datetime, "millisecond", fl_value_new_int(s->wMilliseconds));
    fl_value_set_string_take(summary, "date", datetime);
}
static void init_filter_map(FilterRepoMap * filterMap, FlValue * filter) {
    hashmap_init(filterMap, hashmap_hash_integer, hash_integer_compare);
    size_t m_length = fl_value_get_length(filter);
    for (size_t i = 0; i < m_length; ++i) {
        FlValue* mv = fl_value_get_list_value(filter, i);
        struct message* msg = (struct message*)malloc(sizeof(struct message));
        msg->signal_ids = list_new();
        msg->id = fl_value_get_int(fl_value_lookup_string(mv, "id"));
        FlValue* ss = fl_value_lookup_string(mv, "signals");
        size_t s_length = fl_value_get_length(ss);
        for (size_t j = 0; j < s_length; ++j) {
            FlValue* skey = fl_value_get_map_key(ss, j);
            const char* sid = fl_value_get_string(skey);
            debug_info("parse_blf sid is %s\n", sid);
            list_node_t *s_node = list_node_new((void*)sid);
            list_rpush(msg->signal_ids, s_node);
        }
        hashmap_put(filterMap, &msg->id, msg);
    }
}

bool parse_blf(const char *path, FlValue* filter, FlValue* result) {
    debug_info("parse_blf in");

    FilterRepoMap filterMap;
    init_filter_map(&filterMap, filter);

    CBData cbData {
        .filterMap = &filterMap,
        .result = result
    };

    FlValue* summary = fl_value_new_map();
    fl_value_set_string_take(result, "summary", summary);
    FlValue* data = fl_value_new_map();
    fl_value_set_string_take(result, "data", data);

    FILE *fp = fopen(path, "rb");
    blfReader_processFile(fp, 1, testtime, testprint, &cbData);
    return true;
}

/*
 * Parser for BLF files.
 *
 * mFile       FILE pointer of input file
 * verbose_level  0: silent, 1: verbose, 2: debug
 * msgRxCb  callback function for received messages
 * cbData   pointer to opaque callback data
 */
void blfReader_processFile(FILE *fp, int verbose_level, timeCb_t timeCb,
                           msgRxCb_t msgRxCb, void *cbData)
{

  debug_info("blfReader_processFile in");
  VBLObjectHeaderBase base;
  VBLFileStatisticsEx statistics;
  BLFHANDLE h;
  success_t success;

  /* get header */
  h = blfCreateFile(fp);
  if(h == NULL) {
    debug_info("blfReader_processFile: cannot open file\n");
    goto read_error;
  }

  /* diagnose header */
  statistics.mStatisticsSize = sizeof(statistics);
  blfGetFileStatisticsEx(h, &statistics);

  timeCb(&statistics.mMeasurementStartTime, &statistics.mLastObjectTime, cbData);
  /* print some file statistics */
  if(verbose_level >= 1) {
    debug_info("BLF Start  : ");
    blfSystemTimePrint(&statistics.mMeasurementStartTime);
    debug_info("\nBLF End    : ");
    blfSystemTimePrint(&statistics.mLastObjectTime);
    debug_info("\nObject Count: %u\n", statistics.mObjectCount);
  }

  success = 1;
  while(success && blfPeekObject(h, &base)) {
    switch(base.mObjectType) {
    case BL_OBJ_TYPE_CAN_MESSAGE:
    case BL_OBJ_TYPE_CAN_MESSAGE2:
    case BL_OBJ_TYPE_CAN_FD_MESSAGE:
    case BL_OBJ_TYPE_CAN_FD_MESSAGE_64:
      {
        canMessage_t canMessage;

        /* select type-dependent data structure and setup pointers to
           the relevant elements for further processing */
        VBLCANMessage message;
        VBLCANMessage2 message2;
        VBLCANFDMessage fdmessage;
        VBLCANFDMessage64 fdmessage64;

        size_t messageSize;
        VBLObjectHeaderBase *headerBase;
        uint8_t  *data;
        VBLObjectHeader *header;
        uint8_t  *dlc;
        void     *channel;
        size_t    channelSize;
        uint8_t   maxDLC;

        switch(base.mObjectType)
          {
          case BL_OBJ_TYPE_CAN_MESSAGE:
            messageSize = sizeof(message);
            headerBase = &message.mHeader.mBase;
            data = message.mData;
            header = &message.mHeader;
            dlc = &message.mDLC;
            channel = &message.mChannel;
            channelSize = sizeof(message.mChannel);
            maxDLC = 8;
            break;
          case BL_OBJ_TYPE_CAN_MESSAGE2:
            messageSize = sizeof(message2);
            headerBase = &message2.mHeader.mBase;
            data = message2.mData;
            header = &message2.mHeader;
            dlc = &message2.mDLC;
            channel = &message2.mChannel;
            channelSize = sizeof(message2.mChannel);
            maxDLC = 8;
            break;
          case BL_OBJ_TYPE_CAN_FD_MESSAGE:
            messageSize = sizeof(fdmessage);
            headerBase = &fdmessage.mHeader.mBase;
            data = fdmessage.mData;
            header = &fdmessage.mHeader;
            dlc = &fdmessage.mDLC;
            channel = &fdmessage.mChannel;
            channelSize = sizeof(fdmessage.mChannel);
            maxDLC = 64;
            break;
          case BL_OBJ_TYPE_CAN_FD_MESSAGE_64:
            messageSize = sizeof(fdmessage64);
            headerBase = &fdmessage64.mHeader.mBase;
            data = fdmessage64.mData;
            header = &fdmessage64.mHeader;
            dlc = &fdmessage64.mDLC;
            channel = &fdmessage64.mChannel;
            channelSize = sizeof(fdmessage64.mChannel);
            maxDLC = 64;
            break;
          }
          
        *headerBase = base;
        success = blfReadObjectSecure(h, headerBase, messageSize);
        
        if(success) {
          /* diagnose data */
          if(*dlc > maxDLC) {
            debug_info("invalid CAN message lenght: DLC > %d\n", maxDLC);
            goto read_error;
          }

          /* copy data */
          if(channelSize == 2) {
            canMessage.bus = *(uint16_t *)channel;
          } else {
            canMessage.bus = *(uint8_t *)channel;
          }
          canMessage.dlc = *dlc;
          memcpy(canMessage.byte_arr, data, *dlc);

          /* direct copy of message id required due to packed alignment */
          switch(base.mObjectType) {
          case BL_OBJ_TYPE_CAN_MESSAGE:
            canMessage.id = message.mID;
            break;
          case BL_OBJ_TYPE_CAN_MESSAGE2:
            canMessage.id = message2.mID;
            break;
          case BL_OBJ_TYPE_CAN_FD_MESSAGE:
            canMessage.id = fdmessage.mID;
            break;
          case BL_OBJ_TYPE_CAN_FD_MESSAGE_64:
            canMessage.id = fdmessage64.mID;
            break;
          }

          /* parse time */
          blfVBLCANMessageParseTime(header, &(canMessage.t.tv_sec),
                                    &(canMessage.t.tv_nsec), &(canMessage.time));

          /* debug: dump message */
          if(verbose_level >= 2) {
            blfCANMessageDump(&canMessage);
          }
          
          /* invoke canMessage receive callback function */
          msgRxCb(&canMessage, cbData);

          /* free allocated memory */
          blfFreeObject(h, headerBase);
        }
      }
      break;
    default:
      /* skip all other objects */
      success = blfSkipObject(h, &base);
      if(verbose_level >= 2) {
        debug_info("skipping object type = %d\n", base.mObjectType);
      }
      break;
    }
  }
  blfCloseHandle(h);
  return;

read_error:
  debug_info("error reading BLF file, aborting\n");
  return;
}
