#include "frame_to_flvalue.h"
#include "list/list.h"
#include "dbc_parser.h"
#include "libwecan.h"



FlValue* can_frame_to_flvalue(struct can_frame_s *frame, unsigned int num) {
    g_autoptr(FlValue) result = fl_value_new_list();

    for(int i = 0; i < num; ++i, ++frame) {
        struct message_meta * m_meta = get_message_meta_by_id(frame->can_id);
        // debug_info("notifyListeners  msg id:%d", p->ID);
        if(m_meta == NULL) continue;
        list_iterator_t *it = list_iterator_new(m_meta->signal_ids, LIST_HEAD);
        list_node_t *t = NULL;
        while((t = list_iterator_next(it)) != NULL ) {
            struct signal_meta * s_meta = get_signal_meta_by_id((const char *)t->val);
            if(s_meta == NULL) continue;
            uint64_t origvalue = extract(frame->data, s_meta->start_bit, s_meta->length, UNSIGNED, MOTOROLA);
            double signal_value = origvalue * s_meta->scaling;
            FlValue* fv_signal = fl_value_new_map();
            fl_value_set_string_take(fv_signal, "name", fl_value_new_string(s_meta->name));
            fl_value_set_string_take(fv_signal, "value", fl_value_new_float(signal_value));
            fl_value_set_string_take(fv_signal, "mid", fl_value_new_int(s_meta->mid));
            fl_value_append_take(result, fv_signal);
        }
        list_iterator_destroy(it);
    }
    return result;
}

FlValue* canfd_frame_to_flvalue(struct canfd_frame_s *frame, unsigned int num) {
    g_autoptr(FlValue) result = fl_value_new_list();
    for(int i = 0; i < num; ++i, ++frame) {
        struct message_meta * m_meta = get_message_meta_by_id(frame->can_id);
        // debug_info("notifyListeners  msg id:%d", p->ID);
        if(m_meta == NULL) continue;
        list_iterator_t *it = list_iterator_new(m_meta->signal_ids, LIST_HEAD);
        list_node_t *t = NULL;
        while((t = list_iterator_next(it)) != NULL ) {
            struct signal_meta * s_meta = get_signal_meta_by_id((const char *)t->val);
            if(s_meta == NULL) continue;
            uint64_t origvalue = extract(frame->data, s_meta->start_bit, s_meta->length, UNSIGNED, MOTOROLA);
            double signal_value = origvalue * s_meta->scaling;
            FlValue* fv_signal = fl_value_new_map();
            fl_value_set_string_take(fv_signal, "name", fl_value_new_string(s_meta->name));
            fl_value_set_string_take(fv_signal, "value", fl_value_new_float(signal_value));
            fl_value_set_string_take(fv_signal, "mid", fl_value_new_int(s_meta->mid));
            fl_value_append_take(result, fv_signal);
        }
        list_iterator_destroy(it);
    }
    return result;
}
