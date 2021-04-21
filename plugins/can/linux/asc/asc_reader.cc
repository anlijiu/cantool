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

#define buffer_size 1048576L //1M=1024*1024

#ifndef O_BINARY
#define O_BINARY 0
#endif

typedef enum {
  unset = 0,
  decimal = 10,
  hexadecimal = 16
} numBase_t;

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

static void processheaderline(char *str, FlValue *result, can_trace_cb cb) {
    char *tail = split(str, " ");   /* get first token */
    char *cp;

    // printf("processheader: str after split:%s\n", str);
    if(!tail) return;

    if(!strcmp(str, "date")) {

        const char* months[12] = { 
            "Jan", "Feb", "Mar", "Apr", "May", "Jun",
            "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"
        };  
        int h = 0;
        int m = 0;
        int s = 0;
        int d = 0;
        int Y = 0;
        int ms = 0;
        int MM = 0;
        char ampm[3];
        char M[4];

        sscanf(tail, "%*[a-zA-Z] %s %d %d:%d:%d.%d %s %d", M, &d, &h, &m, &s, &ms, ampm, &Y);
        if(strcmp(ampm, "pm") == 0) {
            h+=12;
        }
        for(int i = 0; i < 12; ++i) {
            if(strcmp(M, months[i]) == 0) {
                MM = i+1;
            }
        }

        FlValue* datetime = fl_value_new_map();
        fl_value_set_string_take(datetime, "year", fl_value_new_int(Y));
        fl_value_set_string_take(datetime, "month", fl_value_new_int(MM));
        fl_value_set_string_take(datetime, "day", fl_value_new_int(d));
        fl_value_set_string_take(datetime, "hour", fl_value_new_int(h));
        fl_value_set_string_take(datetime, "minute", fl_value_new_int(m));
        fl_value_set_string_take(datetime, "second", fl_value_new_int(s));
        fl_value_set_string_take(datetime, "millisecond", fl_value_new_int(ms));
        fl_value_set_string_take(result, "date", datetime);

    } else if(!strcmp(str,"base")) {              /* parse numeric base */
        cp = strtok(tail, " ");    /* dec/hex */
        if(!cp) return;
        // printf("processheader: cp addr is %p\n", cp);
        if(!strcmp(cp,"dec")) {
            fl_value_set_string_take(result, "numbase", fl_value_new_string("decimal"));
            numbase = decimal;
            debug_info("processheader: dec\n");
        } else if(!strcmp(cp,"hex")) {
            fl_value_set_string_take(result, "numbase", fl_value_new_string("hex"));
            numbase = hexadecimal;
            debug_info("processheader: hec\n");
        } else {
        }
    } else if(!strcmp(str,"internal")) {
    } else if(!strcmp(str,"Begin")) {
        // printf("processheader: begin content\n");
        in_asc_header = false;
    } else if(!strcmp(str,"Start")) {
        // printf("processheader: start content\n");
        in_asc_header = false;
    } else if(!strcmp(str, "//")) {
        char *version = split(tail, " ");   /* get first token */
        if(version != NULL && !strcmp(tail, "version")) {
            debug_info("processheader: version:%s\n", version);
        }
        in_asc_header = false;
    } else if(str[0] >=48 && str[0] <=57) {
        in_asc_header = false;
    }

    if(!in_asc_header) {
        cb(result);
    }

    debug_info("processheader: end in_asc_header:%s\n", in_asc_header ? "true":"false");
}

static void processline(char *str, filter_repo_map* filter, FlValue* result) {

    debug_info("processline: processline start %s\n", str);
    char *cp, *buffer_lasts;

    if(numbase == unset) {
        debug_info("processline: missing numeric base\n");
    }

    // printf("len: %ld, processline :%s    -\n", strlen(str), str);

    cp = strtok_r (str,"\t", &buffer_lasts);   /* get first token */

    if(!cp) return;


    debug_info("processline: processline time: %s\n", cp);

    double t = strtod(cp, NULL) * 1000; //换算成ms

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

    cp = strtok_r(NULL, "\t", &buffer_lasts); if(cp == NULL || !isdigit((int)*cp)) return;//正常的数据帧这个应该是bus通道
    int bus = atoi(cp);
    printf("processcontent cp is: %s, bus is %d\n", cp, bus);

      /* get message identifier */
    cp = strtok_r(NULL, "\t", &buffer_lasts); if(cp == NULL) return;
    uint32_t id = 0;
    if(numbase == hexadecimal) {
        id = strtol(cp, NULL, 16);
    } else {
        id = atoi(cp);
    }
    debug_info("processcontent  id is %d %ld\n", id, hashmap_size(filter));

    struct message* m = hashmap_get(filter, &id);
    if(m == NULL) {
        // debug_info("processcontent  m is NULL return\n");
        return;
    }

    cp = strtok_r(NULL, "\t", &buffer_lasts); if(cp == NULL) return;

    if((cp[0] != 'R') || (cp[1] != 'x')) return;

    cp = strtok_r(NULL, "\t", &buffer_lasts); if(cp == NULL) return;
    cp = strtok_r(NULL, "\t", &buffer_lasts); if(cp == NULL) return;

    int dlc = atoi(cp);
    debug_info("processcontent  dlc is %d\n", dlc);

    uint8_t data[8];
    for(int i = 0; i < dlc; i++) {
      cp = strtok_r(NULL, " ", &buffer_lasts); if(cp == NULL) break;
      data[i] = (uint8_t)strtoul(cp,NULL,numbase);
    }

    list_iterator_t *it = list_iterator_new(m->signal_ids, LIST_HEAD);
    list_node_t *nt = NULL;
    while((nt = list_iterator_next(it)) != NULL ) { 
        struct signal_meta * s_meta = get_signal_meta_by_id((const char *)nt->val);
        // debug_info("processcontent s_meta name is %s\n ", s_meta->name);
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

    debug_info("processline data: %d %d %d %d %d %d %d %d\n", data[0], data[1], data[2], data[3], data[4], data[5], data[6], data[7]);
}

// bool parse_asc(const char *path, FlValue* filter, FlValue* result) {
//     init_static_variables();
//     filter_repo_map filter_repo;
//     hashmap_init(&filter_repo, hashmap_hash_integer, hash_integer_compare);
// 
//     FlValue* summary = fl_value_new_map();
//     fl_value_set_string_take(result, "summary", summary);
//     FlValue* data = fl_value_new_map();
//     fl_value_set_string_take(result, "data", data);
// 
//     size_t m_length = fl_value_get_length(filter);
//     for (size_t i = 0; i < m_length; ++i) {
//         FlValue* mv = fl_value_get_list_value(filter, i);
//         struct message* msg = (struct message*)malloc(sizeof(struct message));
//         msg->signal_ids = list_new();
//         msg->id = fl_value_get_int(fl_value_lookup_string(mv, "id"));
//         FlValue* ss = fl_value_lookup_string(mv, "signals");
//         size_t s_length = fl_value_get_length(ss);
//         for (size_t j = 0; j < s_length; ++j) {
//             FlValue* skey = fl_value_get_map_key(ss, j);
//             const char* sid = fl_value_get_string(skey);
//             printf("parse_asc sid is %s\n", sid);
//             list_node_t *s_node = list_node_new((void*)sid);
//             list_rpush(msg->signal_ids, s_node);
//         }
//         hashmap_put(&filter_repo, &msg->id, msg);
//     }
// 
//     const uint32_t* key;
//     struct message * value;
// 
//     hashmap_foreach(key, value, &filter_repo) {
//         printf("filter id: %d\n", *key);
//     }
// 
//     int fd = open( path, O_RDONLY|O_BINARY);
//     long size = filesize(fd);
//     long chunks = size / (buffer_size);
//     printf ( "size = %ld, chunks is %ld\n" , size, chunks);
// 
//     fl_value_set_string_take(summary, "size", fl_value_new_int(size));
//     fl_value_set_string_take(summary, "chunks", fl_value_new_int(chunks));
// 
//     char* buffer = (char*)malloc((buffer_size+1) * sizeof(char));
//     
//     memset( buffer, 0, sizeof(char)*(buffer_size+1));
//     size_t readsize = 0;
//     // char lastline[65] = "\0";
//     size_t line_size = 1024;
//     char currline[line_size];
//     memset( currline, 0, sizeof(char)*line_size);
//     bool half_enter = false;
//     while((readsize = read(fd, buffer, buffer_size)) != 0) {
//         buffer[ readsize ] = '\0';
// 
//         char * p = currline + strlen(currline);
//         char * q = buffer;
//         while(*q != '\0') {
//             if(*q == '\r') {
//                 half_enter = true;
//                 *p++ = '\0';
//                 if(in_asc_header) {
//                     processheaderline(currline, summary);
//                 } else {
//                     processline(currline, &filter_repo, data);
//                 }
//                 memset( currline, 0, sizeof(char)*line_size );
//                 p = currline;
//             } else if(*q == '\n') {
//                 if(half_enter) {
//                     half_enter = false;
//                 } else {
//                     *p++ = '\0';
//                     if(in_asc_header) {
//                         processheaderline(currline, summary);
//                     } else {
//                         processline(currline, &filter_repo, data);
//                     }
//                     memset( currline, 0, sizeof(char)*line_size );
//                     p = currline;
//                 }
//             } else {
//                 *p = *q;
//                 p++;
//             }
//             q++;
//         }
// 
//         memset( buffer, 0, sizeof(char)*(buffer_size+1));
//     }
//     
//     struct message * mptr;
//     hashmap_foreach_data(mptr, &filter_repo) {
//         list_destroy(mptr->signal_ids);
//         free(mptr);
//     }
//     hashmap_cleanup(&filter_repo);
//     free(buffer);
// 
//     return true;
// }

bool parse_asc(const char *path, filter_repo_map* filter, can_trace_cb cb) {

    init_static_variables();

    FlValue* summary = fl_value_new_map();
    fl_value_set_string_take(summary, "name", fl_value_new_string("summary"));

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
    size_t line_size = 1024;
    char currline[line_size];
    memset( currline, 0, sizeof(char)*line_size);
    bool half_enter = false;
    int sequence = 0;
    while((readsize = read(fd, buffer, buffer_size)) != 0) {
        buffer[ readsize ] = '\0';

        FlValue* result = fl_value_new_map();
        FlValue* data = fl_value_new_map();
        fl_value_set_string_take(result, "name", fl_value_new_string("data"));
        fl_value_set_string_take(result, "sequence", fl_value_new_int(sequence));
        fl_value_set_string_take(result, "data", data);
        if(readsize < buffer_size) {
            fl_value_set_string_take(result, "isEnd", fl_value_new_bool(true));
        }

        sequence++;

        char * p = currline + strlen(currline);
        char * q = buffer;
        while(*q != '\0') {
            if(*q == '\r') {
                half_enter = true;
                *p++ = '\0';
                if(in_asc_header) {
                    processheaderline(currline, summary, cb);
                } else {
                    processline(currline, filter, data);
                }
                memset( currline, 0, sizeof(char)*line_size );
                p = currline;
            } else if(*q == '\n') {
                if(half_enter) {
                    half_enter = false;
                } else {
                    *p++ = '\0';
                    if(in_asc_header) {
                        processheaderline(currline, summary, cb);
                    } else {
                        processline(currline, filter, data);
                    }
                    memset( currline, 0, sizeof(char)*line_size );
                    p = currline;
                }
            } else {
                *p = *q;
                p++;
            }
            q++;
        }

        cb(result);
        memset( buffer, 0, sizeof(char)*(buffer_size+1));
    }
    
    free(buffer);

    return true;
}

