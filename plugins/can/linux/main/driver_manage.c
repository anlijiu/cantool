#include "driver_manage.h"

#include <dirent.h>
#include <dlfcn.h>
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <unistd.h>
#include <pthread.h>
#include "list/list.h"

static list_t *handles;

static char* get_current_exe_path() {
    char str[260];
    char* buf = calloc(sizeof(char), 260);
    snprintf(str, sizeof(str), "/proc/self/exe");
    readlink(str, buf, sizeof(str));
    printf("current work path: %s\n", buf);
    return buf;
}

static char * get_dir_of_abs_path(const char* abs_path) {
    char* last_slash = strrchr(abs_path, '/');
    if(last_slash) {
        char* result = (char*) calloc(sizeof(char), last_slash - abs_path + 2);
        snprintf(result, last_slash - abs_path + 1, "%s", abs_path);
        return result;
    } else {
        return NULL;
    }
}

static char* get_plugin_name(char* filename) {
    // Find where the file name starts, and where it ends before
    // the extension starts
    char* last_slash = strrchr(filename, '/');
    char* name_start = last_slash ? last_slash + 1 : filename;
    char* last_dot = strrchr(filename, '.');

    // We only care about file names that have a .so extension
    if (!last_dot || strcmp(last_dot, ".so"))
        return NULL;
    char* result = (char*) malloc(last_dot - name_start + 2);
    // snprintf(result, last_dot - name_start + 1, "%s%c", name_start, '\0');
    snprintf(result, last_dot - name_start + 1, "%s", name_start);

    printf("%ld, result:%s ,     %ld\n",strlen(result), result,  last_dot - name_start);
    // result[last_dot - name_start] = '\0';
    return result; 
}

// void load_driver(char* fullpath) {
static void* load_driver(void* param) {
  char* fullpath = param;
  printf("%s start,  fullpath: %s\n", __func__, fullpath);
  // int (*init_module)(void);
  char *error;

  void* handle = dlopen(fullpath,
                  RTLD_NOW | RTLD_GLOBAL);
                  // RTLD_NOW);

  if (!handle) {
    fprintf(stderr, "%s\n", dlerror());
    exit(EXIT_FAILURE);
  }

  // list_node_t *node = list_node_new(handle);
  // list_rpush(handles, node);

  // init_module = (int (*)(void)) dlsym(handle, "init_module");

  error = dlerror();
  if (error != NULL) {
    fprintf(stderr, "%s\n", error);
    exit(EXIT_FAILURE);
  }

  // printf("invoke init_module result: %d\n", (*init_module)());
  // dlclose(handle);
  printf("%s %s done ! \n", __func__, fullpath);
  free(fullpath);
  return NULL;
}

void load_drivers() {
  handles = list_new();
  char* exe = get_current_exe_path();
  char* workdir = get_dir_of_abs_path(exe);
  char* driverdir = calloc(sizeof(char), strlen(workdir) + 9);
  sprintf(driverdir, "%s/%s", workdir, "drivers");
  printf("%s, exe: %s\n", __func__, exe);
  printf("%s, workdir: %s\n", __func__, workdir);
  printf("%s, driverdir: %s\n", __func__, driverdir);
  DIR* dir = opendir(driverdir);
  struct dirent* direntry;
  while ((direntry = readdir(dir))) {
      char * name = get_plugin_name(direntry->d_name);
      printf("%s, d_name in while: %s\n", __func__, direntry->d_name);
      if (!name)
          continue;
      char* fullpath = calloc(sizeof(char), 1000);
      memset(fullpath, 0 , 1000);
      sprintf(fullpath, "%s/%s.so", driverdir, name);
      // load_driver(fullpath);

      pthread_t thread;
      printf("%s, pthread_create fullpath: %s\n", __func__, fullpath);
      int err = pthread_create(&thread, NULL, &load_driver, fullpath);
      if (err) {
          /* Failed */
          printf("phread_create error in load_drivers errno:%d, error:%s\n", err, strerror(err));
      } else {
          /* Succeeded */
          pthread_detach(thread);
      }
  }
  printf("%s, load driver finished\n", __func__);

  free(exe);
  free(workdir);
  free(driverdir);

  /* According to the ISO C standard, casting between function
     pointers and 'void *', as done above, produces undefined results.
     POSIX.1-2003 and POSIX.1-2008 accepted this state of affairs and
     proposed the following workaround:

     *(void **) (&cosine) = dlsym(handle, "cos");

     This (clumsy) cast conforms with the ISO C standard and will
     avoid any compiler warnings.

     The 2013 Technical Corrigendum to POSIX.1-2008 (a.k.a.
     POSIX.1-2013) improved matters by requiring that conforming
     implementations support casting 'void *' to a function pointer.
     Nevertheless, some compilers (e.g., gcc with the '-pedantic'
     option) may complain about the cast used in this program. */
}

void unload_drivers() {
    list_iterator_t *it = list_iterator_new(handles, LIST_HEAD);
    list_node_t *t;
    while((t = list_iterator_next(it))) {
        if(t == NULL) break;
        void* handle = (void*)t->val;
        dlclose(handle);
        list_remove(handles, handle);
    }

    list_iterator_destroy(it);
    list_destroy(handles);
}
