#include <flutter_linux/flutter_linux.h>
#include <string.h>
#include "replay_operator.h"
#include "log.h"
#include "asc_reader.h"


static char* g_path;

static const char *get_filename_ext(const char *filename) {
    const char *dot = strrchr(filename, '.');
    if(!dot || dot == filename) return "";
    return dot + 1;
}

void replay_operator_set_file_path(const char* path) {
    if(g_path != NULL) {
        g_path = (char*)realloc(g_path, strlen(path));
    } else {
        g_path = (char*)malloc(strlen(path));
    }

    if(g_path == NULL) {
        debug_info("alloc memory failed in %s.\n", __FUNCTION__);
    }
    
    strcpy(g_path, path);
}

const char* replay_operator_get_file_path() {
    return g_path;
}

void replay_operator_get_filted_signals(FlValue *filter, FlValue *result)
{
    if(g_path == NULL) return;

    bool ok = false;

    if(strcmp("asc", get_filename_ext(g_path)) == 0) {
        ok = parse_asc(g_path, filter, result);
    } else if(strcmp("blf", get_filename_ext(g_path)) == 0) {
    } else {
    }
}
