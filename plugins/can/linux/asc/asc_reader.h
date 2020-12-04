#ifndef INCLUDE_ASCREAD_H
#define INCLUDE_ASCREAD_H

#include <stdio.h>
#include <candbc-types.h>
#include <time.h>
#include <flutter_linux/flutter_linux.h>
#include <stdbool.h>

bool parse_asc(const char *path, FlValue* filter, FlValue* result);

#endif
