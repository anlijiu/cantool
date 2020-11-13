/*  ascReader.c --  parse ASC files
    Copyright (C) 2007-2011 Andreas Heitmann

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


#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <unistd.h> 
#include <dirent.h>
#include <stdio.h>
#include <string.h>
#include <ctype.h>
#include <stdint.h>
#include <stdlib.h>
#include <time.h>
#include "asc_reader.h"
#include "list.h"
#include "hashmap.h"
#include "dbc_parser.h"
#include "can_defs.h"
#include "libwecan.h"
#include "log.h"

#define buffer_size 3072L //3*1024

#ifndef O_BINARY
#define O_BINARY 0
#endif

typedef enum {
  unset = 0,
  decimal = 10,
  hexadecimal = 16
} numBase_t;

struct message {
    uint32_t id;
    list_t * signal_ids = NULL;
};

typedef HASHMAP(uint32_t, struct message) filter_repo_map;

static numBase_t numbase = unset;
static bool in_asc_header = true;

static long filesize(int fd) {
    // long curr_pos = lseek64(fd, 0, SEEK_CUR);
    long size = lseek(fd, 0, SEEK_END);
    // lseek64(fd, curr_pos, SEEK_SET);
    lseek(fd, 0, SEEK_SET);
    return size;
}

static void init_static_variables() {
    numbase = unset;
    in_asc_header = true;
}

static char *split(char *str, const char *delim)
{
    char *p = strstr(str, delim);
    if (p == NULL) return NULL;     // delimiter not found
    *p = '\0';                      // terminate string after head
    return p + strlen(delim);       // return tail substring
}

char* printtm(struct tm tm)
{
  static char buf[100];
  sprintf(buf, "%04d-%02d-%02d %02d:%02d:%02d (gmtoff=%ld, isdst=%d)",
    tm.tm_year + 1900, tm.tm_mon + 1, tm.tm_mday,
    tm.tm_hour, tm.tm_min, tm.tm_sec,
    tm.tm_gmtoff, tm.tm_isdst);
  return buf;
}

static void processheaderline(char *str, FlValue *result) {
    char *tail = split(str, " ");   /* get first token */
    char *cp;

    // printf("processheader: str after split:%s\n", str);
    if(!tail) return;

    if(!strcmp(str, "date")) {
        struct tm *timeinfo = (struct tm *)malloc(sizeof(struct tm));
        debug_info("processheader: date:%s|\n", tail);
        time_t rawtime = 0;
        memset(timeinfo, 0, sizeof(struct tm));
        debug_info("timeinfo after memset 0 : %s",  printtm(*timeinfo));
        // strptime(tail, "%a %b %d %I:%M:%S %p %y",  timeinfo);
        strptime("Mon Sep 21 10:56:01 pm 2020", "%a %b %d %I:%M:%S %p %y",  timeinfo);

        debug_info("processheader: date:%s|timeinfo:%s|\n", tail, printtm(*timeinfo));
        rawtime = mktime(timeinfo);
        debug_info("rawtime: %ld, %s", rawtime, printtm(*timeinfo));


        // struct tm *ti = getdate("Mon Sep 21 10:56:01 pm 2020");
        // printf(" ti: %s              year:%d, hour:%d\n", printtm(*ti), ti->tm_year, ti->tm_hour);


        fl_value_set_string_take(result, "date", fl_value_new_string(tail));
        fl_value_set_string_take(result, "timestamp", fl_value_new_int(rawtime));
    } else if(!strcmp(str,"base")) {              /* parse numeric base */
        cp = strtok(tail, " ");    /* dec/hex */
        if(!cp) return;
        // printf("processheader: cp addr is %p\n", cp);
        if(!strcmp(cp,"dec")) {
            fl_value_set_string_take(result, "numbase", fl_value_new_string("decimal"));
            numbase = decimal;
            // printf("processheader:dec\n");
        } else if(!strcmp(cp,"hex")) {
            fl_value_set_string_take(result, "numbase", fl_value_new_string("hex"));
            numbase = hexadecimal;
            // printf("processheader:hec\n");
        } else {
        }
    } else if(!strcmp(str,"internal")) {
    } else if(!strcmp(str,"Begin")) {
        // printf("processheader: begin content\n");
        in_asc_header = false;
    } else if(!strcmp(str,"Start")) {
        // printf("processheader: start content\n");
        in_asc_header = false;
    }

    printf("processheader: end\n");
}

static void processline(char *str, filter_repo_map* filter, FlValue* result) {

    char *cp, *buffer_lasts;

    if(numbase == unset) {
        fprintf(stderr,"processline(): missing numeric base\n");
    }

    // printf("len: %ld, processline :%s    -\n", strlen(str), str);

    cp = strtok_r (str," ", &buffer_lasts);   /* get first token */

    if(!cp) return;

    double t = strtod(cp, NULL);

    // char *tp;                                                                   
    // char *time_lasts;
    // tp = strtok_r(cp, ".", &time_lasts); if(tp == NULL) return;
    // // tp = split(cp, "."); if(tp == NULL) return;
    // 
    // //单位微秒
    // int64_t t = atoi(tp) * 1000000;
    // int64_t nt = 0;
    // 
    // tp = strtok_r(NULL, " ", &time_lasts); if(tp == NULL) return;
    // //1秒=1000毫秒 1毫秒=1000微秒 1微秒=1000纳秒
    // for(int i = 0; i < 6; i++) {
    //     nt *= 10; 
    //     if(isdigit((int)*tp)) {
    //         nt += (*tp) - '0';
    //         tp++;
    //     } 
    // }
    // t += nt;
    // printf("processcontent  t: %f\n", t);

    cp = strtok_r(NULL, " ", &buffer_lasts); if(cp == NULL) return;
    // int bus = atoi(cp);
    // printf("processcontent  bus is %d\n", bus);

      /* get message identifier */
    cp = strtok_r(NULL, " ", &buffer_lasts); if(cp == NULL) return;
    uint32_t id = atoi(cp);
    // printf("processcontent  id is %d %ld\n", id, hashmap_size(filter));

    struct message* m = hashmap_get(filter, &id);
    if(m == NULL) return;

    cp = strtok_r(NULL, " ", &buffer_lasts); if(cp == NULL) return;

    if((cp[0] != 'R') || (cp[1] != 'x')) return;

    cp = strtok_r(NULL, " ", &buffer_lasts); if(cp == NULL) return;
    cp = strtok_r(NULL, " ", &buffer_lasts); if(cp == NULL) return;

    int dlc = atoi(cp);
    // printf("processcontent  dlc is %d\n", dlc);

    uint8_t data[8];
    for(int i = 0; i < dlc; i++) {
      cp = strtok_r(NULL, " ", &buffer_lasts); if(cp == NULL) break;
      data[i] = (uint8_t)strtoul(cp,NULL,numbase);
    }

    list_iterator_t *it = list_iterator_new(m->signal_ids, LIST_HEAD);
    list_node_t *nt = NULL;
    while((nt = list_iterator_next(it)) != NULL ) { 
        struct signal_meta * s_meta = get_signal_meta_by_id((const char *)nt->val);
        printf("processcontent s_meta name is %s\n ", s_meta->name);
        if(s_meta == NULL) continue;
        FlValue *signal_list = fl_value_lookup_string(result, (const char *)nt->val);
        if(signal_list == NULL) {
            signal_list = fl_value_new_list();
            fl_value_set_string_take(result, (const char *)nt->val, signal_list);
        }

        uint64_t origvalue = extract(data, s_meta->start_bit, s_meta->length, UNSIGNED, MOTOROLA);
        double signal_value = origvalue * s_meta->scaling;
        
        FlValue* fv_signal = fl_value_new_map();
        fl_value_set_string_take(fv_signal, "value", fl_value_new_float(signal_value));
        fl_value_set_string_take(fv_signal, "time", fl_value_new_float(t));
        fl_value_append_take(signal_list, fv_signal);
    }   
    list_iterator_destroy(it);

    printf(" %d %d %d %d %d %d %d %d\n", data[0], data[1], data[2], data[3], data[4], data[5], data[6], data[7]);
}

bool parse_asc(const char *path, FlValue* filter, FlValue* result) {
    init_static_variables();
    filter_repo_map filter_repo;
    hashmap_init(&filter_repo, hashmap_hash_integer, hash_integer_compare);

    FlValue* summary = fl_value_new_map();
    fl_value_set_string_take(result, "summary", summary);
    FlValue* data = fl_value_new_map();
    fl_value_set_string_take(result, "data", data);

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
            printf("parse_asc sid is %s\n", sid);
            list_node_t *s_node = list_node_new((void*)sid);
            list_rpush(msg->signal_ids, s_node);
        }
        hashmap_put(&filter_repo, &msg->id, msg);
    }

    const uint32_t* key;
    struct message * value;

    hashmap_foreach(key, value, &filter_repo) {
        printf("filter id: %d\n", *key);
    }

    int fd = open( path, O_RDONLY|O_BINARY);
    long size = filesize(fd);
    long chunks = size / (buffer_size);
    printf ( "size = %ld, chunks is %ld\n" , size, chunks);

    fl_value_set_string_take(summary, "size", fl_value_new_int(size));
    fl_value_set_string_take(summary, "chunks", fl_value_new_int(chunks));

    char* buffer = (char*)malloc((buffer_size+1) * sizeof(char));
    
    memset( buffer, 0, sizeof(char)*(buffer_size+1));
    size_t readsize = 0;
    // char lastline[65] = "\0";
    char currline[64];
    memset( currline, 0, sizeof(char)*64);
    bool half_enter = false;
    while((readsize = read(fd, buffer, buffer_size)) != 0) {
        buffer[ readsize ] = '\0';

        char * p = currline + strlen(currline);
        char * q = buffer;
        while(*q != '\0') {
            if(*q == '\r') {
                half_enter = true;
                *p++ = '\0';
                if(in_asc_header) {
                    processheaderline(currline, summary);
                } else {
                    processline(currline, &filter_repo, data);
                }
                memset( currline, 0, sizeof(currline) );
                p = currline;
            } else if(*q == '\n') {
                if(half_enter) {
                    half_enter = false;
                } else {
                    *p++ = '\0';
                    if(in_asc_header) {
                        processheaderline(currline, summary);
                    } else {
                        processline(currline, &filter_repo, data);
                    }
                    memset( currline, 0, sizeof(char)*64 );
                    p = currline;
                }
            } else {
                *p = *q;
                p++;
            }
            q++;
        }

        memset( buffer, 0, sizeof(char)*(buffer_size+1));
    }
    
    struct message * mptr;
    hashmap_foreach_data(mptr, &filter_repo) {
        list_destroy(mptr->signal_ids);
        free(mptr);
    }
    hashmap_cleanup(&filter_repo);
    free(buffer);

    return true;
}
