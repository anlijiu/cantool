#ifndef __THREAD__POOL_H__
#define __THREAD__POOL_H__

#ifdef __cplusplus
extern "C" {
#endif

void thread_pool_init();
int thread_pool_add_work(void (*function_p)(void*), void* arg_p);
void thread_pool_fini();

#ifdef __cplusplus
}
#endif

#endif // __THREAD__POOL_H__
