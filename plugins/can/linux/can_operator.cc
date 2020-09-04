#include "can_operator.h"
#include "can_device.h"
#include "cstr.h"
#include <string.h>
#include <pthread.h>
#include <stdio.h>
#include <sys/time.h>
#include "list/list.h"
#include "hashmap.h"
#include "dbc_parser.h"
#include "libwecan.h"
#include "log.h"


// unsigned int (*build)(*PVCI_CAN_OBJ);
// void (*destroy)(PVCI_CAN_OBJ);
typedef HASHMAP(char, signal_assembler) signal_assembler_map;
typedef HASHMAP(uint32_t, message_assembler) message_assembler_map;

static unsigned int deviceCount = 0;


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
    pthread_t thread;
    pthread_cond_t cond;
    pthread_mutex_t mutex;
    bool flag;
};


static can_operator_sender sender;
static can_operator_receiver receiver;
static can_device *device;
static bool inited = false;


static void notifyListeners(PVCI_CAN_OBJ pObj, unsigned int len) {
    if(!has_dbc_synced()) return;
    PVCI_CAN_OBJ p = pObj;
    debug_info("notifyListeners  start %d", len);
    g_autoptr(FlValue) result = fl_value_new_list();

    for(int i = 0; i < len; ++i, ++p) {
        debug_info("notifyListeners  p->ID: %d ", p->ID);
        struct message_meta * m_meta = get_message_meta_by_id(p->ID);
        if(m_meta == NULL) continue;
        list_iterator_t *it = list_iterator_new(m_meta->signal_ids, LIST_HEAD);
        while(list_node_t *t = list_iterator_next(it)) {
            if(t == NULL) break;
            struct signal_meta * s_meta = get_signal_meta_by_id((const char *)t->val);
            if(s_meta == NULL) continue;
            uint64_t origvalue = extract(pObj->Data, s_meta->start_bit, s_meta->length, UNSIGNED, MOTOROLA);
            double signal_value = origvalue * s_meta->scaling;
            g_autoptr(FlValue) fv_signal = fl_value_new_map();
            fl_value_set_string_take(fv_signal, "name", fl_value_new_string(s_meta->name));
            fl_value_set_string_take(fv_signal, "value", fl_value_new_float(signal_value));
            fl_value_set_string_take(fv_signal, "mid", fl_value_new_int(s_meta->mid));
            fl_value_append(result, fv_signal);
        }
        list_iterator_destroy(it);
    }

    list_iterator_t *it = list_iterator_new(receiver.listeners, LIST_HEAD);
    while(list_node_t *t = list_iterator_next(it)) {
        if(t == NULL) break;
        can_listener_t func = (can_listener_t )t->val;
        if(func != NULL) {
            (func)(result);
        }
    }

    list_iterator_destroy(it);
}

static signal_assembler* get_signal_assembler_by_id(const char * name) {
    return hashmap_get(&sender.s_assembler_map, name);
}



void *can_send_func(void *param)
{
    VCI_CAN_OBJ can_obj[message_meta_size()];
    size_t index = 0;
    const uint32_t* m_key;
    message_assembler* m_assembler;

    struct timeval now;
    struct timespec outtime;
    pthread_mutex_lock(&sender.mutex);
    while (sender.flag) {
        index = 0;
        hashmap_foreach(m_key, m_assembler, &sender.m_assembler_map) {
            debug_info("can_send_func  %d ", *m_key);
            list_iterator_t *it = list_iterator_new(m_assembler->meta->signal_ids, LIST_HEAD);
            can_obj[index].ID = m_assembler->id;
            can_obj[index].ExternFlag = 0;
            can_obj[index].RemoteFlag = 0;
            can_obj[index].DataLen = m_assembler->meta->length;
            while(list_node_t *t = list_iterator_next(it)) {
                if(t == NULL) break;
                const char * sname = (const char *)t->val;
                signal_assembler * sassembler = get_signal_assembler_by_id(sname);
                if(sassembler != NULL) {
                    struct signal_meta * smeta = get_signal_meta_by_id(sname);
                    insert(can_obj[index].Data, smeta->start_bit, smeta->length, sassembler->raw_value, MOTOROLA);
                }
            }
            index++;

            list_iterator_destroy(it);
        }



        can_device * dev = device;
        bool result = false;
        for(int i = 0; i < deviceCount; ++i, ++dev) {
            result  = usb_can_send(dev, i, can_obj, index);
            debug_info("can send result:%d port:%d deviceCount:%d  count is %ld   %x,%x,%x,%x,%x,%x,%x,%x",
                    result, i, deviceCount, index, can_obj[0].Data[0], can_obj[0].Data[1],
         can_obj[0].Data[2], can_obj[0].Data[3], can_obj[0].Data[4], can_obj[0].Data[5], can_obj[0].Data[6],
          can_obj[0].Data[7]);
        }

        gettimeofday(&now, NULL);
        outtime.tv_sec = now.tv_sec;
        outtime.tv_nsec = 100000 + now.tv_usec * 1000;
        pthread_cond_timedwait(&sender.cond, &sender.mutex, &outtime);
    }
    pthread_mutex_unlock(&sender.mutex);
    return 0;
}

void *can_receive_func(void *param)
{
    debug_info("can_receive_func  in \n");
    unsigned int cache_len = 100;
    VCI_CAN_OBJ can0_cache[cache_len];
    VCI_CAN_OBJ can1_cache[cache_len];
    unsigned int receive_can0_len = 0;
    unsigned int receive_can1_len = 0;

    struct timeval now;
    struct timespec outtime;
    pthread_mutex_lock(&receiver.mutex);
    while (receiver.flag)
    {
        debug_info("can_receive_func  in while\n");
        memset(&can0_cache, 0, sizeof can0_cache);
        memset(&can1_cache, 0, sizeof can1_cache);
        if (device->ports[USB_CAN_PORT_0].started
            && (receive_can0_len = usb_can_receive(device, USB_CAN_PORT_0, can0_cache, cache_len, 20)) > 0)
        {
            notifyListeners(can0_cache, receive_can0_len);
        }
        if (device->ports[USB_CAN_PORT_1].started
           && (receive_can1_len = usb_can_receive(device, USB_CAN_PORT_1, can1_cache, cache_len, 20)) > 0)
        {
            notifyListeners(can1_cache, receive_can1_len);
        }

        receive_can0_len = 0;
        receive_can1_len = 0;
        gettimeofday(&now, NULL);
        outtime.tv_sec = now.tv_sec + 1;
        outtime.tv_nsec = now.tv_usec * 1000;
        pthread_cond_timedwait(&receiver.cond, &receiver.mutex, &outtime);
    }
    pthread_mutex_unlock(&receiver.mutex);
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
    pthread_mutex_init(&receiver.mutex, NULL);
    pthread_cond_init(&receiver.cond, NULL);
    int err = pthread_create(&receiver.thread, NULL, &can_receive_func, NULL);
    if (err != 0)
    {
        printf("can_operator_init create receiver thread error: %d !", err);
        return false;
    }
    pthread_detach(receiver.thread);
    return true;
}

void stop_receiving_message() {
    receiver.flag = false;
    pthread_mutex_lock(&receiver.mutex);
    pthread_cond_signal(&receiver.cond);
    pthread_mutex_unlock(&receiver.mutex);
}

bool can_operator_init()
{
    debug_info("can_operator_init  start");
    if (inited)
        return true;
    inited = true;

    hashmap_init(&sender.m_assembler_map, hashmap_hash_integer, hash_integer_compare);
    hashmap_init(&sender.s_assembler_map, hashmap_hash_string, strcmp);

    receiver.listeners = list_new();
    receiver.flag = true;
    sender.flag = true;

    deviceCount = can_find();
    if(deviceCount == 0) return false;

    usb_can_new(&device, deviceCount);
    can_device * dev = device;
    for(int i = 0; i < deviceCount; ++i, ++dev) {
        usb_can_start(dev);
    }

    start_receiving_message();
    debug_info("can_operator_init  end");
    return true;
}

void can_operator_destroy()
{
    debug_info("can_operator_destroy in");
    receiver.flag = false;
    sender.flag = false;
    stop_receiving_message();
    usb_can_free(device);
    list_destroy(receiver.listeners);
    inited = false;
}

void can_operator_fire()
{
    start_sending_message();
}

void can_operator_ceasefire()
{
    stop_sending_message();
}

void can_operator_add_listener(can_listener_t t) {
  debug_info("can_operator_add_listener  start");
  list_node_t *listener = list_node_new((void*)t);
  debug_info("can_operator_add_listener  111111  ");
  list_rpush(receiver.listeners, listener);
  debug_info("can_operator_add_listener  end");
}
void can_operator_remove_listener(can_listener_t t) {
    list_node_t *listener = list_find(receiver.listeners, (void*)t);
    if(listener != NULL) {
        list_remove(receiver.listeners, listener);
    }
}
void can_operator_clear_listener();

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
