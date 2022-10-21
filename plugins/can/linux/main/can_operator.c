#include "can_operator.h"
#include <stdio.h>
#include <pthread.h>
#include <string.h>
#include <sys/time.h>
#include "dbc_parser.h"
#include "list/list.h"
#include "hashmap/hashmap.h"
#include "libwecan.h"
#include "mpscq.h"

typedef HASHMAP(char, signal_assembler) signal_assembler_map;
typedef HASHMAP(uint32_t, message_assembler) message_assembler_map;

struct can_operator_sender
{
    message_assembler_map m_assembler_map;
    signal_assembler_map s_assembler_map;
    pthread_t thread;
    pthread_cond_t cond;
    pthread_mutex_t mutex;
    bool flag;
};

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

void *can_send_func(void *param)
{
    size_t index = 0;
    size_t len = message_meta_size();
    const uint32_t* m_key;
    message_assembler* m_assembler;

    struct timeval now;
    struct timespec outtime;
    pthread_mutex_lock(&sender.mutex);
    struct can_frame_s * frames = malloc(sizeof(struct can_frame_s) * len);
    struct canfd_frame_s * fdframes = malloc(sizeof(struct canfd_frame_s) * len);
    while (sender.flag) {
        index = 0;
        struct can_frame_s * frame = frames;
        struct canfd_frame_s * fdframe = fdframes;
        uint8_t * data;
        hashmap_foreach(m_key, m_assembler, &sender.m_assembler_map) {
            list_iterator_t *it = list_iterator_new(m_assembler->meta->signal_ids, LIST_HEAD);
            struct list_node *t = list_iterator_next(it);
            if(is_synced_dbc_canfd()) {
                data = fdframe->data;
            } else {
                data = frame->data;
            }

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
            frame++;
            fdframe++;
            index++;

            list_iterator_destroy(it);
        }

        if(is_synced_dbc_canfd()) {
            send_canfd_frame(fdframes, index);
        } else {
            send_can_frame(frames, index);
        }

        gettimeofday(&now, NULL);
        outtime.tv_sec = now.tv_sec;
        outtime.tv_nsec = 100000 + now.tv_usec * 1000;
        pthread_cond_timedwait(&sender.cond, &sender.mutex, &outtime);
    }
    free(frames);
    free(fdframes);
    pthread_mutex_unlock(&sender.mutex);
    return 0;
}

bool start_sending_message() {
    sender.flag = true;
    pthread_mutex_init(&sender.mutex, NULL);
    pthread_cond_init(&sender.cond, NULL);
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
