#ifndef DBC_PARSER
#define DBC_PARSER

#include <flutter_linux/flutter_linux.h>
#include <gtk/gtk.h>


int parse_dbc(const char *path, FlValue* result);

#endif //DBC_PARSER