#define _GNU_SOURCE

#include <sys/types.h>
#include <sys/stat.h>
#include <sys/mman.h>
#include <fcntl.h>
#include <unistd.h> 
#include <dirent.h>
#include <stdio.h>
#include <string.h>
#include <ctype.h>
#include <stdint.h>
#include <stdlib.h>
#include <stdbool.h>
#include <time.h>
#include "asc_reader.h"
#include "list/list.h"
#include "hashmap/hashmap.h"
#include "dbc_parser.h"
#include "can_defs.h"
#include "libwecan.h"
#include "log.h"


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

#if 0
static long filesize(int fd) {
    // long curr_pos = lseek64(fd, 0, SEEK_CUR);
    long size = lseek(fd, 0, SEEK_END);
    // lseek64(fd, curr_pos, SEEK_SET);
    lseek(fd, 0, SEEK_SET);
    return size;
}
#endif

/** this code from https://stackoverflow.com/questions/40144132/read-large-chunk-into-memory-and-process-line-by-line **/

/** * O_DIRECT is a Linux extension (i.e. not in POSIX). You need to define _GNU_SOURCE to get it. You can either define it at the top of source file, like:
 *      #define _GNU_SOURCE
 * or define while compiling with -D_GNU_SOURCE. e.g.
 *      gcc -D_GNU_SOURCE file.c
 */


// 16M buffer
#define BUFSIZE ( 16UL * 1024UL * 1024UL )
/**
 * vector asc line format
 *   header
 *     date <WeekDay> <Month> <Date> <Fulltime> <Year>
 *     base <hex|dec> timestamps <absolute|relative>
 *     <" "|no> internal events logged
 *   version
 *     // version <major>.<minor>.<patch>
 *   split information
 *     //<time> previous log file: <filename>
 *   can message
 * (v7.2)  <Time> <Channel> <ID> <Dir> d <DLC> <D0> <D1>...<D8> <MessageFlags>
 * (v7.5)  <Time> <Channel> <ID> <Dir> d <DLC> <D0> <D1>...<D8> Length = <MessageDuration> BitCount = <MessageLength> <MessageFlags>
 * (v8.0)  <Time> <Channel> <ID> <Dir> d <DLC> <D0> <D1>...<D8> Length = <MessageDuration> BitCount = <MessageLength> ID = <IDnum> <MessageFlags>
 *   can extended message 
 * (v7.2)  <Time> <Channel> <ID>x <Dir> d <DLC> <D0> <D1>...<D8> <MessageFlags>
 * (v7.5)  <Time> <Channel> <ID>x <Dir> d <DLC> <D0> <D1>...<D8> Length = <MessageDuration> BitCount = <MessageLength> <MessageFlags>
 * (v8.0)  <Time> <Channel> <ID>x <Dir> d <DLC> <D0> <D1>...<D8> Length = <MessageDuration> BitCount = <MessageLength> ID = <IDnum>x <MessageFlags>
 *   can remote message
 * (v7.2)  <Time> <Channel> <ID> <Dir> r
 * (v7.5)  <Time> <Channel> <ID> <Dir> r Length = <MessageDuration> BitCount = <MessageLength> ID = <IDnum>x
 * (v8.5)  <Time> <Channel> <ID> <Dir> r <DLC> Length = <MessageDuration> BitCount = <MessageLength> ID = <IDnum>x
 *   can error frame
 *     <Time> <Channel> ErrorFrame
 *     <Time> <Channel> ErrorFrame ECC:<ECC>
 *     <Time> <Channel> ErrorFrame Flags = <flags> CodeExt = <codeExt> Code = <code> ID = <ID> DLC = <DLC> Position = <Position> Length = <Length>
 *   can bus statistics
 *     <Time> <Channel> Statistic: D <StatNumber> R <StatNumber> XD <StatNumber> XR <StatNumber> E <StatNumber> O <StatNumber> B <StatPercent>%
 *   can error event
 *     <Time> CAN <Channel> Status:<Error>
 *   can overload frame
 *     <Time> <Channel> OverloadFrame
 *
 *   can message on canfd bus
 *     <Time> CANFD <Channel> <Dir> <ID> <SymbolicName> <BRS> <ESI> <DLC> <DataLength> <D1> … <D8> <MessageDuration> <MessageLength> <Flags> <CRC> <BitTimingConfArb> <BitTimingConfData> <BitTimingConfExtArb> <BitTimingConfExtData>
 *   canfd extends message on canfd bus
 *     <Time> CANFD <Channel> <Dir> <ID> <SymbolicName> <BRS> <ESI> <DLC> <DataLength> <D1> … <D8> <MessageDuration> <MessageLength> <Flags> <CRC> <BitTimingConfArb> <BitTimingConfData>> <BitTimingConfData> <BitTimingConfExtArb> <BitTimingConfExtData>
 *   can remote frame on canfdbus
 *     <Time> CANFD <Channel> <Dir> <ID> <SymbolicName> <BRS> <ESI> <DLC> <DataLength> <MessageDuration> <MessageLength> <Flags> <CRC> <BitTimingConfArb> <BitTimingConfData>> <BitTimingConfData> <BitTimingConfExtArb> <BitTimingConfExtData>
 *   canfd message
 *     <Time> CANFD <Channel> <Dir> <ID> <SymbolicName> <BRS> <ESI> <DLC> <DataLength> <D1> … <D64> <MessageDuration> <MessageLength> <Flags> <CRC> <BitTimingConfArb> <BitTimingConfData> <BitTimingConfExtArb> <BitTimingConfExtData>
 *   canfd extends message
 *     <Time> CANFD <Channel> <Dir> <ID> <SymbolicName> <BRS> <ESI> <DLC> <DataLength> <D1> … <D64> <MessageDuration> <MessageLength> <Flags> <CRC> <BitTimingConfArb> <BitTimingConfData> <BitTimingConfExtArb> <BitTimingConfExtData>
 *   canfd error frame
 *     <Time> CANFD <Channel> <Dir> ErrorFrame <ErrorText> <flags> <code> <codeExt> <Phase> <Position> <ID> <BRS> <ESI> <DLC> <DataLength> <D1> … <D64> <MessageDuration> <extFlags> <CRC> <BitTimingConfArb> <BitTimingConfData> <BitTimingConfExtArb> <BitTimingConfExtData>
 *   log trigger
 *     <Time> log trigger event
 *   log direct start
 *     <Time> log direct start (<PreTrigger>ms)
 *   log direct stop
 *     <Time> log direct stop (<PostTrigger>ms)
 *   begin trigger event
 *     Begin Triggerblock <WeekDay> <Month> <Date> <FullTime> <Year>
 *   end trigger event
 *     End TriggerBlock
 *   environment event
 *     <Time> <evname> := <value>
 *   system variables event
 *     <Time> SV: <svtype> <symbolic> <signed> <path> = <value>
 *     <Time> SV: <svtype> <symbolic> <signed> <path> = <valuetype><count> <value>
 *   macro signal event: CAN,LIN,FLEXRAY
 *     <Time> <bussystem> <channel> <node>::<message>::<signal> = <value>
 *   GPS
 *     <Time> GPS device: <channel> La:<latitude> Lo: <longitude> Alt: <altitude> Sp: <speed> Co: <course>
 *   comment
 *     <Time> Comment: <type> <comment text>
 *   Global marker events
 *     <Time> <type> <background color> <foreground color> GMGroup: <groupname> GMMarker: <marker name> GMDescription: <description>
 *   Test structure events
 *     begin event
 *       <time> TFS: [<execID>,<elementID>] <event text>
 *     abort event
 *       <time> TFS: [<execID>,<elementID>] <verdict> <event text>
 *     end event
 *       <time> TFS: [<execID>,<elementID>] <verdict> <event text>
 */

// first集 tokens
typedef enum token_first_t {
	TOK_FIRST_BEGIN,       // 'Begin Triggerblock'
	TOK_FIRST_END,         // 'End Triggerblock'
    TOK_FIRST_DATE,        // 'date'
    TOK_FIRST_TIME,        // <time>   0.00000 之类的
    TOK_FIRST_BASE,        // 'base'
    TOK_FIRST_COMMENT,     // '//'
} token_first_t;

// static const char * token_begin_triggerblock = "Begin Triggerblock";
// static const char * token_end_triggerblock = "End Triggerblock";
// static const char * token_date = "date";
// static const char * token_base = "base";

typedef enum piece_t {
	PIECE_FIRST,
	PIECE_SECOND,
	PIECE_THIRD,
	PIECE_FOURTH,
} piece_t;

static bool isnum(char c) {
    if(c > 57 || c < 48) {
        return false;
    } else {
        return true;
    }
}

char** splitStr(char* str, unsigned int* tokensCounter) {
	/* split the string by white spaces, and add NULL at the end
		return an array of tokens (dynamically allocated)
		tokensCounter is updated at the end to save the number of tokens
		e.g.
			Input: "  This is a sample string   "
			Output: {"This", "is", "a", "sample", "string", NULL}
	*/
	// NOTE: the memory allocated for resultArr must be freed afterwards
	// using free() manually in subsequent code

	const char* delims = " \n\t\v\f\r";

	unsigned int numTokens = 0;
	char** resultArr = NULL;
	char* found = NULL;
	do {
		found = strsep(&str, delims);
		if ((found == NULL) || (strcmp(found, "") != 0)) {
			++numTokens;
			resultArr = (char**)realloc(resultArr, numTokens * sizeof(char*));
			if (!resultArr) { // on error
				free(found);
				free(resultArr);
				exit(-1);
			}
			resultArr[numTokens-1] = found;
		}
	} while (found != NULL);

	*tokensCounter = numTokens;

	free(found);

	return resultArr;
}

void parse_date(char *p) {
    unsigned int count = 0;

    char** result = splitStr(p, &count);

	for (unsigned int i = 0; i < count; ++i) {
		char* resultStr = result[i];
		if (resultStr) {
			printf("%s\n", resultStr);
		}
		else {
			printf("[NULL]\n");
		}
	}
    free(result);
}

void parse_version(char *p) {

}

static const char* weekdays[7] = {
    "Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"
};
static const char* months[12] = { 
    "Jan", "Feb", "Mar", "Apr", "May", "Jun",
    "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"
};
void parse_time(char** result, int* weekday, int* month, int* day, int* hour, int* minute, int* second, int* ms, int* year) {

    char M[4] = { '\0' };
    char W[4] = { '\0' };
    char ampm[3] = { '\0' };
    sscanf(result[0], "%s", W);
    sscanf(result[1], "%s", M);
    sscanf(result[2], "%d", day);
    sscanf(result[3], "%d:%d:%d.%d", hour, minute, second, ms);
    sscanf(result[4], "%s", ampm);
    sscanf(result[5], "%d", year);

    for(int i = 0; i < 12; ++i) {
        if(strcmp(M, months[i]) == 0) {
            *month = i+1;
        }
    }
    for(int i = 0; i < 7; ++i) {
        if(strcmp(W, weekdays[i]) == 0) {
            *weekday = i+1;
        }
    }
    if(strcmp(ampm, "pm") == 0) {
        (*hour) += 12;
    }
}

void process_line(char* line, filter_repo_map* filter, FlValue* summary, FlValue* fl_data) {
    char* p = line;

    debug_info("orig line: %s\n", p);
    unsigned int count = 0;
    char** result = splitStr(p, &count);
    if(count < 3) return;
    if(isnum(result[0][0])) {//首字符为数字
        double t = strtod(result[0], NULL) * 1000; //换算成ms
        if(strcmp("Rx", result[3]) == 0 || strcmp("Tx", result[3]) == 0) {//rx 消息
            bool canfd = is_synced_dbc_canfd();
            uint32_t canid = 0;
            // 乘用车标准帧， 重型车辆用扩展帧，我现在是做乘用车的， 所以。。。
            if(canfd) {
                canid = strtoul(result[4], NULL, numbase == hexadecimal ? 16 : 10);
            } else {
                canid = strtoul(result[2], NULL, numbase == hexadecimal ? 16 : 10);
            }

            debug_info("asc parseline  canid: %u\n", canid);
            struct message* m = hashmap_get(filter, &canid);
            if(m == NULL) {
                return;
            }

            int dlc = atoi(result[5]);
            //因为只关注dlc和data， 所以result[1]此处是否canfd 不关心
            uint8_t *data = calloc(sizeof(uint8_t), dlc);
            for(int i = 0; i < dlc; i++) {
                data[i] = (uint8_t)strtoul(result[6+i], NULL, numbase);
                debug_info("d[%d]: %d, ",i, data[i]);
            }

            list_iterator_t *it = list_iterator_new(m->signal_ids, LIST_HEAD);
            list_node_t *nt = NULL;
            while((nt = list_iterator_next(it)) != NULL ) { 
                struct signal_meta * s_meta = get_signal_meta_by_id((const char *)nt->val);
                debug_info("processcontent s_meta name is %s\n ", s_meta->name);
                if(s_meta == NULL) continue;
                FlValue *signal_list = fl_value_lookup_string(fl_data, (const char *)nt->val);
                if(signal_list == NULL) {
                    signal_list = fl_value_new_list();
                    fl_value_set_string_take(fl_data, (const char *)nt->val, signal_list);
                }
            
                uint64_t origvalue = extract(data, s_meta->start_bit, s_meta->length, UNSIGNED, MOTOROLA);
                double signal_value = origvalue * s_meta->scaling;
                
                FlValue* fv_signal = fl_value_new_map();
                fl_value_set_string_take(fv_signal, "value", fl_value_new_float(signal_value));
                fl_value_set_string_take(fv_signal, "time", fl_value_new_float(t));
                fl_value_append_take(signal_list, fv_signal);
            }   
            list_iterator_destroy(it);
            free(data);
        }
        debug_info(" time: %fms\n", t);
    } else {
        if(strcmp("date", result[0]) == 0) {
            debug_info(" date count : %d\n", count);
            int weekday = 0, month, day, hour, minute, second, ms = 0, year;

// date[0]: date
// date[1]: 19/10/2022
// date[2]: 12:27:33.402
            if(count == 4) {//tsmaster asc 
                sscanf(result[1], "%d/%d/%d", &day, &month, &year);
                sscanf(result[2], "%d:%d:%d.%d", &hour, &minute, &second, &ms);
            } else if(count == 8) {//vector format count is 8
                parse_time(&result[1], &weekday, &month, &day, &hour, &minute, &second, &ms, &year);
            } else {
                return;
            }

            FlValue* datetime = fl_value_new_map();
            fl_value_set_string_take(datetime, "year", fl_value_new_int(year));
            fl_value_set_string_take(datetime, "month", fl_value_new_int(month));
            fl_value_set_string_take(datetime, "day", fl_value_new_int(day));
            fl_value_set_string_take(datetime, "hour", fl_value_new_int(hour));
            fl_value_set_string_take(datetime, "minute", fl_value_new_int(minute));
            fl_value_set_string_take(datetime, "second", fl_value_new_int(second));
            fl_value_set_string_take(datetime, "millisecond", fl_value_new_int(ms));
            fl_value_set_string_take(summary, "date", datetime);
            debug_info("date weekday: %d, month: %d, day: %d, hour: %d, minute: %d, second: %d, ms: %d, year: %d\n", weekday, month, day, hour, minute, second, ms, year);
        } else if(strcmp("base", result[0]) == 0) {
            if(strcmp("hex", result[1]) == 0) {
                numbase = hexadecimal;
                fl_value_set_string_take(summary, "numbase", fl_value_new_string("hex"));
                debug_info("numberbase: hex\n");
            } else if(strcmp("dec", result[2]) == 0) {
                numbase = decimal;
                fl_value_set_string_take(summary, "numbase", fl_value_new_string("decimal"));
                debug_info("numberbase: dec\n");
            }
        } else if(strcmp("//", result[0]) == 0) {
            if(strcmp("version", result[1]) == 0) {
                int major, minor, patch;
                sscanf(result[2], "%d.%d.%d", &major, &minor, &patch);
                FlValue* version = fl_value_new_map();
                fl_value_set_string_take(version, "major", fl_value_new_int(major));
                fl_value_set_string_take(version, "minor", fl_value_new_int(minor));
                fl_value_set_string_take(version, "patch", fl_value_new_int(patch));
                fl_value_set_string_take(summary, "version", version);
                debug_info("version: %d.%d.%d\n", major, minor, patch);
            }
        } else if(strcmp("Begin", result[0]) == 0 && strcmp("Triggerblock", result[1]) == 0) {
            int weekday = 0, month, day, hour, minute, second, ms, year;
            parse_time(&result[2], &weekday, &month, &day, &hour, &minute, &second, &ms, &year);
            debug_info(" begin trigger  weekday: %d, month: %d, day: %d, hour: %d, minute: %d, second: %d, ms: %d, year: %d\n", weekday, month, day, hour, minute, second, ms, year);
        }
    }
    free(result);
}

bool parse_asc(const char *path, filter_repo_map* filter, can_trace_cb cb) {
    debug_info("%s in. path: %s\n", __func__ , path);

    numbase = unset;
    in_asc_header = true;

    int fd = open( path, O_RDONLY | O_DIRECT );
    FILE *fp = fdopen( fd, "rb" );

    FlValue* wrapper = fl_value_new_map();

    FlValue* summary = fl_value_new_map();

    FlValue* data = fl_value_new_map();

    fl_value_set_string_take(wrapper, "data", data);
    fl_value_set_string_take(wrapper, "summary", summary);

    // assuming a POSIX OS - could also use malloc()/free()
    char *buffer = ( char * ) mmap( NULL, BUFSIZE, PROT_READ | PROT_WRITE,
            MAP_PRIVATE | MAP_ANONYMOUS, -1, 0 );
    setvbuf( fp, buffer, _IOFBF, BUFSIZE );

    char *line = NULL;
    size_t len = 0;

    for ( ;; )
    {
        ssize_t currentLen = getline( &line, &len, fp );
        if ( currentLen < 0 )
        {
            break;
        }

        process_line(line, filter, summary, data);
    }

    cb(wrapper);

    free( line );
    fclose( fp );
    munmap( buffer, BUFSIZE );
    return true;
}
