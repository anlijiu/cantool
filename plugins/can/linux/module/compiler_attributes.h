#ifndef __LINUX_COMPILER_ATTRIBUTES_H
#define __LINUX_COMPILER_ATTRIBUTES_H

#if __has_attribute(__copy__)
# define __copy(symbol)                 __attribute__((__copy__(symbol)))
#else
# define __copy(symbol)
#endif


#define __section(section)              __attribute__((__section__(section)))

// #define __init		                    __section(".init.text")
// #define __exit                          __section(".exit.text") 
#define __init		                    __attribute__((constructor))
#define __exit                          __attribute__((destructor))

#endif //__LINUX_COMPILER_ATTRIBUTES_H
