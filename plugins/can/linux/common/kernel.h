#ifndef __KERNEL_H__
#define __KERNEL_H__

#ifndef offsetof
#define offsetof(TYPE, MEMBER) ((size_t) &((TYPE*)0)->MEMBER)
#endif

#define container_of(ptr, type, member) ({				\
	void *__mptr = (void *)(ptr);					\
	((type *)(__mptr - offsetof(type, member))); })


#endif //__KERNEL_H__
