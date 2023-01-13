#include "can_operator.h"
#include <stdio.h>
#include <pthread.h>
#include <string.h>
#include <sys/time.h>
#include <math.h>
#include "dbc_parser.h"
#include "list/list.h"
#include "hashmap/hashmap.h"
#include "libwecan.h"
#include "mpscq.h"

typedef HASHMAP(char, signal_assembler) signal_assembler_map;
typedef HASHMAP(uint32_t, message_assembler) message_assembler_map;

/**
 * 原文链接：https://blog.csdn.net/JAZZSOLDIER/article/details/104258903
 * The futex facility returned an unexpected error code
 * 在 linux 程序执行中若遇到该错误，考虑下是否是如下变量使用了强制内存对齐导致。
 * 
 * 比如：在将如上变量包含到结构体中，强制1字节或2字节内存对齐。
 * 
 * 如：信号量相关 struct semaphore，线程相关的 pthread_mutex_t，以及 pthread_cond_t 等等。
 * 
 * 解决办法：
 * 
 * 1、取消强制内存对齐；
 * 2、不要包含在结构体中或类中；
*/

struct can_operator_sender
{
    message_assembler_map m_assembler_map;
    signal_assembler_map s_assembler_map;
    pthread_t thread;
    pthread_cond_t cond;
    pthread_mutex_t mutex;
    bool flag;
};
// }__attribute__ ((aligned(4)));

struct can_operator_receiver
{
    list_t *listeners;
    list_t *canfd_listeners;
    pthread_t thread;
    pthread_cond_t cond;
    pthread_mutex_t mutex;
    struct mpscq queue;
    bool flag;
};
// }__attribute__ ((aligned(4)));

static struct can_operator_sender sender;
static struct can_operator_receiver receiver;
static bool inited = false;

static signal_assembler* get_signal_assembler_by_id(const char * name) {
    return hashmap_get(&sender.s_assembler_map, name);
}

// typedef struct can_frame_s {
// 	uint16_t can_id;
// 	uint8_t can_dlc;
// 	uint8_t data[CAN_FRAME_MAX_DATA_LEN];
// } __attribute__((packed)) can_frame_t;

// static void *can_receive_func(void *param) {
//     while (receiver.flag) {
//         void *ret = mpscq_dequeue(&receiver.queue);
// 		if(ret) {
//         }
//         printf(" can_operator.c %s while\n", __func__);
//     }
//     printf("%s end\n", __func__);
// }

void fill_sending_data(uint8_t* data, list_t* signal_ids) {
    list_iterator_t *it = list_iterator_new(signal_ids, LIST_HEAD);
    struct list_node *t = list_iterator_next(it);
    while(t) {
        if(t == NULL) break;
        const char * sname = (const char *)t->val;
        signal_assembler * sassembler = get_signal_assembler_by_id(sname);
        if(sassembler != NULL) {
            struct signal_meta * smeta = get_signal_meta_by_id(sname);
            insert(data, smeta->start_bit, smeta->length, sassembler->raw_value, MOTOROLA);
        }
        t = list_iterator_next(it);
    }
    list_iterator_destroy(it);
}

int utc_system_timestamp(char buf[]) {
    const int tmpsize = 21;
    struct timespec now;
    struct tm tm;
    int retval = clock_gettime(CLOCK_REALTIME, &now);
    gmtime_r(&now.tv_sec, &tm);
    strftime(buf, tmpsize, "%Y-%m-%dT%H:%M:%S.", &tm);
    sprintf(buf + tmpsize -1, "%09luZ", now.tv_nsec);
    return retval;
}

void x_ms_later(long period, struct timespec * outtime) {
    long sec = (period / 1000);
    long nsec = (period % 1000) * 1000000;
    // fprintf(stderr, "[start] sec=%ld ns = %ld     sec:%ld, nsec:%ld\n ", outtime->tv_sec, outtime->tv_nsec, sec, nsec);
    if ((outtime->tv_nsec + nsec) > 999999999) {
        outtime->tv_sec += sec + 1;
        outtime->tv_nsec = nsec - (1000000000 - outtime->tv_nsec);
        // fprintf(stderr, "[expected end] sec=%ld ns = %ld\n", outtime->tv_sec, outtime->tv_nsec);
    } else {
        outtime->tv_sec += sec;
        outtime->tv_nsec += nsec;
        // fprintf(stderr, "[expected end] sec=%ld ns = %ld\n", outtime->tv_sec, outtime->tv_nsec);
    }
}

void *can_send_func(void *param)
{
    const uint32_t* m_key;
    message_assembler* m_assembler;

    struct timespec outtime;
    // char timestampbuf[31];
    pthread_mutex_lock(&sender.mutex);
    while (sender.flag) {
        // utc_system_timestamp(timestampbuf);
        // printf("\n\n round start in sending loop,  time %s\n", timestampbuf);

        size_t len = hashmap_size(&sender.m_assembler_map);

        struct can_frame_s * frame = NULL;
        struct canfd_frame_s * fdframe = NULL;
        uint8_t * data;
        if(is_synced_dbc_canfd()) {
            struct canfd_frame_s * fdframes = calloc(sizeof(struct canfd_frame_s), len);
            fdframe = fdframes;
            hashmap_foreach(m_key, m_assembler, &sender.m_assembler_map) {
                fdframe->can_id = m_assembler->id;
                fdframe->can_dlc = m_assembler->meta->length;
                data = fdframe->data;
                fill_sending_data(data, m_assembler->meta->signal_ids);
                fdframe++;
            }
            send_canfd_frame(fdframes, len);
            free(fdframes);
        } else {
            struct can_frame_s * frames = calloc(sizeof(struct can_frame_s), len);
            frame = frames;
            hashmap_foreach(m_key, m_assembler, &sender.m_assembler_map) {
                frame->can_id = m_assembler->id;
                frame->can_dlc = m_assembler->meta->length;
                data = frame->data;
                fill_sending_data(data, m_assembler->meta->signal_ids);
                frame++;
            }
            send_can_frame(frames, len);
            free(frames);
        }

        clock_gettime(CLOCK_MONOTONIC, &outtime);
        long ms_later = 100L;
        x_ms_later(ms_later, &outtime);

        // fprintf(stderr, "rrr[expected end] sec=%ld ns = %ld\n", outtime.tv_sec, outtime.tv_nsec);
        // memset(timestampbuf, 0 , 31 * sizeof(char));
        // utc_system_timestamp(timestampbuf);
        // printf(" round end in sending loop,  time %s\n\n", timestampbuf);

        pthread_cond_timedwait(&sender.cond, &sender.mutex, &outtime);
    }
    pthread_mutex_unlock(&sender.mutex);
    return 0;
}

bool start_sending_message() {
    printf("%s in !", __func__);
    sender.flag = true;
    pthread_condattr_t cond_attr;
    pthread_condattr_init (&cond_attr);
    pthread_condattr_setclock (&cond_attr, CLOCK_MONOTONIC);

    pthread_mutex_init(&sender.mutex, NULL);
    pthread_cond_init(&sender.cond, &cond_attr);
    int err = pthread_create(&sender.thread, NULL, &can_send_func, NULL);
    if (err != 0)
    {
        printf("can_operator_init create sender thread error: %d !", err);
        return false;
    }
    pthread_detach(sender.thread);
    return true;
}

void stop_sending_message() {
    printf("%s in \n", __func__);
    sender.flag = false;
    pthread_mutex_lock(&sender.mutex);
    pthread_cond_signal(&sender.cond);
    pthread_mutex_unlock(&sender.mutex);
}

bool start_receiving_message() {
    mpscq_create(&receiver.queue, 1000);
    // int err = pthread_create(&receiver.thread, NULL, &can_receive_func, NULL);
    // if (err != 0)
    // {
    //     printf("can_operator_init create receiver thread error: %d !", err);
    //     return false;
    // }
    return true;
}

void stop_receiving_message() {
    receiver.flag = false;
    mpscq_destroy(&receiver.queue);
    pthread_join(receiver.thread, NULL);
}

void can_operator_fire()
{
    start_sending_message();
}

void can_operator_ceasefire()
{
    stop_sending_message();
}

void can_operator_add_listener(on_recv_fun_t t) {
  list_node_t *listener = list_node_new((void*)t);
  list_rpush(receiver.listeners, listener);
}
void can_operator_remove_listener(on_recv_fun_t t) {
    list_node_t *listener = list_find(receiver.listeners, (void*)t);
    if(listener != NULL) {
        list_remove(receiver.listeners, listener);
    }
}
void can_operator_clear_listener() {
}

void can_operator_add_canfd_listener(on_canfd_recv_fun_t t) {
  list_node_t *listener = list_node_new((void*)t);
  list_rpush(receiver.canfd_listeners, listener);
}

void can_operator_remove_canfd_listener(on_canfd_recv_fun_t t) {
    list_node_t *listener = list_find(receiver.canfd_listeners, (void*)t);
    if(listener != NULL) {
        list_remove(receiver.canfd_listeners, listener);
    }
}

void can_operator_clear_canfd_listener() {
}


static int on_recv(char* uuid, struct can_frame_s *frames, unsigned int num) {
    printf("%s start , uuid: %s\n", __func__, uuid);
    list_iterator_t *it = list_iterator_new(receiver.listeners, LIST_HEAD);
    list_node_t *t = list_iterator_next(it);
    while(t) {
        if(t == NULL) break;
        on_recv_fun_t func = (on_recv_fun_t)t->val;
        if(func != NULL) {
            (func)(uuid, frames, num);
        }
        t = list_iterator_next(it);
    }

    list_iterator_destroy(it);
    // printf("%s start , uuid: %s\n", __func__, uuid);
    // for(int i = 0; i < num; ++i,++frames) {
    //     printf("%s recv canid: %d\n", __func__, frames->can_id);
    // }
    return num;
}

static int on_canfd_recv(char* uuid, struct canfd_frame_s *frames, unsigned int num) {
    printf("%s start , uuid: %s\n", __func__, uuid);
    list_iterator_t *it = list_iterator_new(receiver.canfd_listeners, LIST_HEAD);
    list_node_t *t = list_iterator_next(it);
    while(t) {
        if(t == NULL) break;
        on_canfd_recv_fun_t func = (on_canfd_recv_fun_t)t->val;
        if(func != NULL) {
            (func)(uuid, frames, num);
        }
        t = list_iterator_next(it);
    }

    list_iterator_destroy(it);
    // printf("%s start , uuid: %s\n", __func__, uuid);
    // for(int i = 0; i < num; ++i,++frames) {
    //     printf("%s recv canfdid: %d\n", __func__, frames->can_id);
    // }
    return num;
}

bool can_operator_init()
{
    printf("can_operator_init  start");
    if (inited)
        return true;
    inited = true;

    hashmap_init(&sender.m_assembler_map, hashmap_hash_integer, hash_integer_compare);
    hashmap_init(&sender.s_assembler_map, hashmap_hash_string, strcmp);

    receiver.listeners = list_new();
    receiver.canfd_listeners = list_new();
    receiver.flag = true;
    sender.flag = true;

    set_receive_listener(on_recv);
    set_canfd_receive_listener(on_canfd_recv);

    start_receiving_message();
    printf("can_operator_init  end");
    return true;
}

void can_operator_destroy()
{
    printf("can_operator_destroy in");
    receiver.flag = false;
    sender.flag = false;
    stop_receiving_message();
    list_destroy(receiver.listeners);
    list_destroy(receiver.canfd_listeners);
    inited = false;
}

void can_operator_add_const_signal_builder(const char* name, double value) {
    signal_assembler * sa = hashmap_get(&sender.s_assembler_map, name);
    if(sa != NULL) {
        sa->raw_value = value;
        sa->transform_type = AMMO_TRANSFORM_CONST;
        return;
    }
    struct signal_meta * meta = get_signal_meta_by_id(name);

    sa = (signal_assembler *)malloc(sizeof(signal_assembler));
    sa->meta = meta;
    sa->transform_type = AMMO_TRANSFORM_CONST;
    strcpy(sa->signal_name, name);
    sa->raw_value = value;

    hashmap_put(&sender.s_assembler_map, sa->signal_name, sa);
}


void can_operator_add_message(uint32_t mid) {
    message_assembler * ma = hashmap_get(&sender.m_assembler_map, &mid);
    if(ma == NULL) {
        ma = (message_assembler *)malloc(sizeof(message_assembler));
        struct message_meta * m_meta = get_message_meta_by_id(mid);
        ma->id = mid;
        ma->meta = m_meta;
        hashmap_put(&sender.m_assembler_map, &ma->id, ma);
    }
}

void can_operator_remove_message(uint32_t mid) {
    message_assembler * ma = hashmap_remove(&sender.m_assembler_map, &mid);
    if(ma != NULL) {
        free(ma);
    }
}
