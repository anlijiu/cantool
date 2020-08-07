#ifndef _ESP_CAN_LIST_H_
#define _ESP_CAN_LIST_H_

#include <stddef.h>

struct list_node {
    struct list_node *prev;
    struct list_node *next;
};

#define LIST_HEAD_INIT(name) { &(name), &(name) }

#define LIST_HEAD(name) \
    struct list_node name = LIST_HEAD_INIT(name)

static inline void INIT_LIST_HEAD(struct list_node *list) {
    list->next = list;
    list->prev = list;
}


/**
 * list_empty - 判断链表是否是空，即一个节点都不存在
 * @head: 欲测试的链表
 */
static inline int list_empty(const struct list_node *head) {
    return head->next == head;
}

/**
 * 在两个已知连续的实体间插入一个新实体
 * 这个方法仅使用在我们知道实体的prev/next指针的内部链表操作
 */
static inline void __list_add(struct list_node *node,
        struct list_node *prev,
        struct list_node *next)
{
    next->prev = node;
    node->next = next;
    node->prev = prev;
    prev->next = node;
}

/**
 * 通过实体的prev/next指针相互指向对方删除实体
 * 
 * 这个方法仅使用在我们知道实体的prev/next指针的内部链表操作
 */
static inline void __list_del(struct list_node *prev, struct list_node *next) {
    next->prev = prev;
    prev->next = next;
}

static inline void __list_del_entry(struct list_node *entry) {
    __list_del(entry->prev, entry->next);
}

/**
 * list_add - 添加一个实体
 * @node: 被添加的新实体
 * @head: 链表头部，新实体被添加在这个head后面
 *
 * 在指定的链表头部后面添加一个新实体。
 * 这有利于实现栈。
 */
static inline void list_add(struct list_node *node, struct list_node *head) {
    __list_add(node, head, head->next);
}

/**
 * list_add_tail - 添加一个新实体
 * @node: 被添加的新实体
 * @head: 链表头部，新实体加被添加在这个head之前
 *
 * 在指定的链表头部之前添加一个新实体。
 * 这对于实现队列有用。
 */
static inline void list_add_tail(struct list_node  *node, struct list_node  *head) {
    __list_add(node, head->prev, head);
}

/**
 * list_del - 从链表中删除一个实体.
 * @entry: 从链表中欲删除的实体.
 * Note:  在entry上执行list_del操作后，对entry执行list_empty操作将不返回true。
 *        因为entry属于未定义状态。
 */
static inline void list_del(struct list_node *entry) {
    __list_del(entry->prev, entry->next);
    entry->next = NULL;
    entry->prev = NULL;
}

/**
 * list_del_init - 从链表中删除一个实体，并且重新将该实体初始化为另一链表的head.
 * @entry: 从链表中欲删除的实体.
 */
static inline void list_del_init(struct list_node  *entry) {
    __list_del_entry(entry);
    INIT_LIST_HEAD(entry);
}

/**
 * list_replace - 将old实体替换成node实体
 * @old : 被替换掉的实体
 * @node : 替换的实体
 *
 * 如果old是一个空的（并不是NULL，空的是指prev/next都指向自己，比如head）,
 * old将会被重写.
 * old 的next/prev 还是指向原来的node， 是否置null?
 */
static inline void list_replace(struct list_node *old,
        struct list_node  *node)
{
    node->next = old->next;
    node->next->prev = node;
    node->prev = old->prev;
    node->prev->next = node;
}

/**
 * list_replace_init - 将old实体替换成node实体，并且重新将old初始化为另一链表的head
 * @old : 被替换掉的实体
 * @node : 替换的实体
 */
static inline void list_replace_init(struct list_node  *old,
        struct list_node  *node) {
    list_replace(old, node);
    INIT_LIST_HEAD(old);
}

/**
 * list_move - 将list从一个链表移动到另一个链表中
 * @list: 欲移动的实体
 * @head: 欲加入的新链表的head
 */
static inline void list_move(struct list_node *list, struct list_node *head) {
    __list_del_entry(list);
    list_add(list, head);
}

/**
 * list_move_tail -  将list从一个链表移动到另一个链表尾部
 * @list: 欲移动的实体
 * @head:  欲加入的新链表的head
 */
static inline void list_move_tail(struct list_node  *list,
        struct list_node  *head) {
    __list_del_entry(list);
    list_add_tail(list, head);
}

/**
 * list_rotate_left - 左向移动节点，把第一个元素移动到最后一个
 * @head: 链表的head节点
 */
static inline void list_rotate_left(struct list_node  *head) {
    struct list_node  *first;

    if (!list_empty(head)) {
        first = head->next;
        list_move_tail(first, head);
    }
}

/**
 * list_is_last - 判断list节点是不是head链表的最后一个节点
 * @list: 欲测试的节点
 * @head: 链表的head节点
 */
static inline int list_is_last(const struct list_node *list,
        const struct list_node *head) {
    return list->next == head;
}

/**
 * list_empty_careful - 测试链表是都为空且未被修改
 * @head: 欲测试的链表
 *
 * 
 * 说明：
 * 测试链表是否为空的，并且检查没有另外的CPU正在更改成员（next或者是prev指针）
 * 
 * 注意：如果在没有同步的情况下使用list_empty_careful函数，
 * 除非其他cpu的链表操作只有list_del_init()，否则仍然不能保证线程安全。
 * 
 */
static inline int list_empty_careful(const struct list_node  *head) {
    struct list_node  *next = head->next;
    return (next == head) && (next == head->prev);
}

 /**
 * list_is_singular - 判断链表是否只有一个节点（除head节点外）
 * @head: 欲测试的链表.
 */
static inline int list_is_singular(const struct list_node  *head) {
    return !list_empty(head) && (head->next == head->prev);
}

/**
 *  __list_cut_position - 将一个列表切分成两个链表
 *           从head节点开始(不包括head）到entry节点结束（包括entry）的节点
 *           全部切割到list链表
 *  @list ： 一个新的链表，将切分的节点全部加入到这个链表
 *  @head ： 待切分链表的开始节点
 *  @entry ： 待切分链表的结束节点，必须和head在一个链表内
 *  注意：list必须是一个空链表，或者是无所谓丢失原有节点的链表，
 *           切分操作将会替换掉list链表原有的元素
 */
static inline void __list_cut_position(struct list_node  *list,
                 struct list_node  *head,
                 struct list_node  *entry) {
    struct list_node  *node_first = entry->next;
    list->next = head->next;
    list->next->prev = list;
    list->prev = entry;
    entry->next = list;
    head->next = node_first;
    node_first->prev = head;
}

/**
 * list_cut_position - 将一个链表切分成2个
 * @list ： 一个新的链表，将切分的节点全部加入到这个链表
 * @head ： 待切分链表的开始节点
 * @entry ： 待切分链表的结束节点，必须和head在一个链表内
 */
static inline void list_cut_position(struct list_node  *list,
        struct list_node  *head, struct list_node  *entry) {
    if (list_empty(head))
        return;
    if (list_is_singular(head) &&
            (head->next != entry && head != entry))
        return;
    if (entry == head)
        INIT_LIST_HEAD(list);
    else
        __list_cut_position(list, head, entry);
}

/**
 * list_clear - 清除以head为头部的链表，将其所有元素挂载到list链表上
 * @head ： 欲清除节点的链表head节点
 *  @list ： 一个新的链表，原链表上的所有节点都将挂载到该链表上
 *  
 */
static inline void  list_clear(struct list_node  *head,struct list_node  *list){
    if(list_empty(head)) return;
    list_cut_position(list,head,head->next);
}

/**
 * __list_splice - 合并链表，将list链表合并到prev和next指向的节点中间
 * @list ： 一个要被合并掉的链表
 * @prev ： 一个要合并其它链表的前驱指针
 * @next ： 一个要合并其它链表的后继指针
 */
static inline void __list_splice(const struct list_node *list,
                   struct list_node *prev,
                   struct list_node *next) {
    struct list_node *first = list->next;
    struct list_node *last = list->prev;
    
    first->prev = prev;
    prev->next = first;
    
    last->next = next;
    next->prev = last;
}

/**
 * list_splice - 合并两个链表，将list合并到以head为头链表的前面，这是为了栈设计的
 * @list: 要被合并的list
 * @head:  添加到第一个链表中的位置
 */
static inline void list_splice(const struct list_node *list,
        struct list_node *head) {
    if (!list_empty(list))
        __list_splice(list, head, head->next);
}

/**
 * list_splice_tail - 将list合并到head为头链表的尾部，这两个链表都是队列
 * @list: 要被合并的list
 * @head: 添加到一个列表中的位置.
 */
static inline void list_splice_tail(struct list_node *list,
        struct list_node  *head) {
    if (!list_empty(list))
        __list_splice(list, head->prev, head);
}

/**
 * list_splice_init - 合并两个链表，并且重新初始化list为空链表
 * @list: 要被合并的list
 * @head:  添加到第一个链表中的位置
 *
 */
static inline void list_splice_init(struct list_node  *list,
        struct list_node  *head) {
    if (!list_empty(list)) {
        __list_splice(list, head, head->next);
        INIT_LIST_HEAD(list);
    }
}

/**
 * list_splice_tail_init - 合并两个链表，并且重新初始化list为空链表
 * @list: 要被合并的list
 * @head: 添加到一个列表中的位置
 */
static inline void list_splice_tail_init(struct list_node *list,
        struct list_node *head) {
    if (!list_empty(list)) {
        __list_splice(list, head->prev, head);
        INIT_LIST_HEAD(list);
    }
}

#ifndef offsetof                                                                                                                                                  
#define offsetof(type, member) ((long) &((type *) 0)->member)
#endif 

/**
 * container_of - cast a member of a structure out to the containing structure
 * @ptr:        the pointer to the member.
 * @type:       the type of the container struct this is embedded in.
 * @member:     the name of the member within the struct.
 *
 */
#define container_of(ptr, type, member) ({                      \
    const typeof( ((type *)0)->member ) *__mptr = (ptr);    \
    (type *)( (char *)__mptr - offsetof(type,member) );})

/**
 * list_entry - 得到实体首地址
 * @ptr:      list_node在实体中的指针.
 * @type:     list_node所在的结构体类型
 * @member:   list_node类型的元素在结构体中的名称.
 */    
#define list_entry(ptr, type, member)  container_of(ptr, type, member)

/**
 * list_first_entry - 得到链表中的第一个实体，即head的next指针指向的实体
 * @ptr:    链表的head指针.
 * @type:	the type of the struct this is embedded in.
 * @member:    list_node的元素在结构体中的名称.
 *
 * 注意：链表不能为空。
 */
#define list_first_entry(ptr, type, member) \
        list_entry((ptr)->next, type, member)

/**
 * list_last_entry - 得到链表中最后一个实体，即head的prev指针指向的实体
 * @ptr:    链表的head指针.
 * @type:	the type of the struct this is embedded in.
 * @member:    list_node的元素在结构体中的名称.
 *
 * 注意：链表不能为空。
 */
#define list_last_entry(ptr, type, member) \
        list_entry((ptr)->prev, type, member)

/**
 * list_first_entry_or_null - 得到链表中的第一个实体，即head的next指针指向的实体
 *                                          如果链表为空，即返回空
* @ptr:    链表的head指针.
 * @type:    链表实体的结构体类型.
 * @member:    list_node的元素在结构体中的名称     
 * 
 * 注意：该API是list_first_entry的一个扩展
 */
#define list_first_entry_or_null(ptr, type, member) \
        (!list_empty(ptr) ? list_first_entry(ptr, type, member) : NULL)

/**
 * list_next_entry - 得到当前链表中pos的下一个实体
 * @pos:    list_node所在结构体的实体指针
 * @member:    list_node在结构体中的名称
 * 
*/
#define list_next_entry(pos, member) \
    list_entry((pos)->member.next, typeof(*(pos)), member)

/**
 * list_prev_entry - 得到当前链表中pos的前一个实体
 * @pos:    list_node所在结构体的实体指针
 * @member:    list_node在结构体中的名称
 */
#define list_prev_entry(pos, member) \
    list_entry((pos)->member.prev, typeof(*(pos)), member)

/**
 * list_for_each    -    往后遍历链表
 * @pos:     list_node结构体的指针，用来作为遍历链表的游标.
 * @head:    链表的head指针.
 */
#define list_for_each(pos, head) \
        for (pos = (head)->next; pos != (head); pos = pos->next)

/**
 * list_for_each_prev - 前向遍历链表
 * @pos:     list_node结构体的指针，用来作为遍历链表的游标
 * @head:    链表的head指针.
 */
#define list_for_each_prev(pos, head) \
        for (pos = (head)->prev; pos != (head); pos = pos->prev)

/**
 * list_for_each_safe -  安全的后向遍历链表，适用于在遍历的过程中需要删除实体的情况
 * @pos:          list_node结构体的指针，用来作为遍历链表的游标
 * @n:           另外一个list_node结构体的指针，临时存储当前遍历的游标
 * @head:    链表的head指针.
 */
#define list_for_each_safe(pos, n, head) \
        for (pos = (head)->next, n = pos->next; pos != (head); \
                pos = n, n = pos->next)

/**
 * list_for_each_prev_safe - 安全的前向遍历链表，适用于在遍历的过程中需要删除实体的情况     
 * @pos:          list_node结构体的指针，用来作为遍历链表的游标
 * @n:           另外一个list_node结构体的指针，临时存储当前遍历的游标
 * @head:    链表的head指针.
 */
#define list_for_each_prev_safe(pos, n, head) \
        for (pos = (head)->prev, n = pos->prev; \
                pos != (head); \
                pos = n, n = pos->prev)

/**
 * list_for_each_entry    -    顺序遍历链表中的实体元素
 * @pos:     链表中实体元素的指针.
 * @head:    lise_node类型的链表头.
 * @member:    list_node元素在实体结构式类型中的名称.
 */
#define list_for_each_entry(pos, head, member) \
        for (pos = list_first_entry(head, typeof(*pos), member); \
                &pos->member != (head); \
                pos = list_next_entry(pos, member))

/**
 * list_for_each_entry_reverse - 倒序遍历链表中的实体元素.
 * @pos:     链表中实体元素的指针.
 * @type ： 链表中实体元素的结构体类型
 * @head:    lise_node类型的链表头.
 * @member:    list_node元素在实体结构式类型中的名称
 */
#define list_for_each_entry_reverse(pos, type,head, member) \
        for (pos = list_last_entry(head, type, member); \
                &pos->member != (head);  \
                pos = list_prev_entry(pos, member))

/**
 * list_prepare_entry - 准备一个实体指针，为list_for_each_entry_continue()中的pos
* @pos:     链表中实体元素的指针.
 * @type ： 链表中实体元素的结构体类型
* @member:    list_node元素在实体结构式类型中的名称.
 *
 * 准备一个实体指针来作为函数list_for_each_entry_continue()中的开始节点
 */
#define list_prepare_entry(pos, type,head, member) \
        ((pos) ? : list_entry(head, type, member))

/**
 * list_for_each_entry_continue - 以链表中的任何一个元素（不包括当前元素）作为起始点遍历链表
* @pos:     链表中实体元素的指针，通常来自于list_prepare_entry.
 * @head:    lise_node类型的链表头.
 * @member:    list_node元素在实体结构式类型中的名称     
 *
 * 从当前pos所属的位置遍历链表
 */
#define list_for_each_entry_continue(pos, head, member)  \
        for (pos = list_next_entry(pos, member); \
                &pos->member != (head); \
                pos = list_next_entry(pos, member))

/**
 * list_for_each_entry_continue_reverse - 以链表中的任何一个元素（不包括当前元素）作为起始点反向遍历链表
* @pos:     链表中实体元素的指针，通常来自于list_prepare_entry.
 * @head:    lise_node类型的链表头.
 * @member:    list_node元素在实体结构式类型中的名称
 *
 * 从当前pos所属的位置反向遍历链表.
 */
#define list_for_each_entry_continue_reverse(pos, head, member) \
        for (pos = list_prev_entry(pos, member); \
                &pos->member != (head); \
                pos = list_prev_entry(pos, member))

/**
 * list_for_each_entry_from - 以当前元素位置遍历链表，便利中包括当前元素
 * @pos:     链表中实体元素的指针
 * @head:    lise_node类型的链表头.
 * @member:    list_node元素在实体结构式类型中的名称
 *
 *
 */
#define list_for_each_entry_from(pos, head, member)  \
        for (; &pos->member != (head); \
                pos = list_next_entry(pos, member))

/**
 * list_for_each_entry_safe - 安全的遍历链表中每一个元素，适用于在遍历的过程中需要删除实体的情况
 * @pos:     遍历链表过程中的实体指针.
 * @n:        遍历过程中临时存储下一个实体的指针
 * @head:    链表中list_node类型的head指针.
 * @member:    链表中list_node类型的原书名.
 */
#define list_for_each_entry_safe(pos, n, head, member) \
        for (pos = list_first_entry(head, member), \
                n = list_next_entry(pos, member); \
                &pos->member != (head);  \
                pos = n, n = list_next_entry(n, member))

/**
 * list_for_each_entry_safe_continue - 安全的遍历链表中的每一个元素，不包括pos指向的当前元素，适用于在遍历的过程中需要删除实体的情况
 * @pos:       遍历链表过程中的实体指针.
 * @n:        遍历过程中临时存储下一个实体的指针
 * @head:    链表中list_node类型的head指针.
 * @member:    链表中list_node类型的原书名.
 *
 */
#define list_for_each_entry_safe_continue(pos, n, head, member)  \
        for (pos = list_next_entry(pos, member),  \
                n = list_next_entry(pos, member); \
                &pos->member != (head); \
                pos = n, n = list_next_entry(n, member))

/**
 * list_for_each_entry_safe_from - 安全的遍历链表中的每一个元素，包括pos指向的当前元素，适用于在遍历的过程中需要删除实体的情况
 * @pos:       遍历链表过程中的实体指针.
 * @n:        遍历过程中临时存储下一个实体的指针
 * @head:    链表中list_node类型的head指针.
 * @member:    链表中list_node类型的原书名. 
 * 
 */
#define list_for_each_entry_safe_from(pos, n, head, member)  \
        for (n = list_next_entry(pos, member); \
                &pos->member != (head); \
                pos = n, n = list_next_entry(n, member))

/**
 * list_for_each_entry_safe_reverse - 安全的反向遍历链表中的每一个元素，适用于在遍历的过程中需要删除实体的情况
 * @pos:       遍历链表过程中的实体指针.
 * @n:        遍历过程中临时存储下一个实体的指针
 * @head:    链表中list_node类型的head指针.
 * @member:    链表中list_node类型的元素名.
 *
 */
#define list_for_each_entry_safe_reverse(pos, n,type, head, member) \
        for (pos = list_last_entry(head, type, member),  \
                n = list_prev_entry(pos, member);  \
                &pos->member != (head);  \
                pos = n, n = list_prev_entry(n, member))

/**
 * list_safe_reset_next - 在list_for_each_entry_safe循环中重置next指针
 * @pos :       list_for_each_entry_safe遍历链表过程中的实体指针
 * @n:        遍历过程中临时存储下一个实体的指针
 * @member:    链表中list_node类型的元素名
 * 
 * 通常情况下，连边会被同时的更改，所以list_safe_reset_next是线程不安全的
 * 例如：在循环体内锁被释放
 * 如果pos游标指向的实体被固定在链表中，并且list_safe_reset_next不在被锁的循环体内调用，则出现异常。
 * 调用list_safe_reset_next请一定要自行注意线程安全问题
*/
#define list_safe_reset_next(pos, n, member) \
        n = list_next_entry(pos, member)

#endif //_ESP_CAN_LIST_H_
