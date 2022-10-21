#include "thread_pool.h"
#include "thpool.h"


static threadpool thpool;// = thpool_init(8);

void thread_pool_init() {
    thpool = thpool_init(8);
}

int thread_pool_add_work(void (*function_p)(void*), void* arg_p) {
    thpool_add_work(thpool, function_p, arg_p);
}

void thread_pool_fini() {
	thpool_wait(thpool);
	thpool_destroy(thpool);
}
