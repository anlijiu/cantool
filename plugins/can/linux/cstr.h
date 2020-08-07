/*
 * File      : cstr.h
 * This file is part of cstr (dynamic string) package
 * COPYRIGHT (C) 2006 - 2018, RT-Thread Development Team
 *
 *  This program is free software; you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation; either version 2 of the License, or
 *  (at your option) any later version.
 *
 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *
 *  You should have received a copy of the GNU General Public License along
 *  with this program; if not, write to the Free Software Foundation, Inc.,
 *  51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
 *
 * Change Logs:
 * Date           Author       Notes
 * 2018-06-07     never        the first version
 * 2018-07-25     never        add append_printf() and modify some APIs
 * 2018-08-30     never        add some APIs and modify some APIs
 *
 * 是的，你猜的没错，从 https://github.com/RT-Thread-packages/cstr 拿得
 */

#ifndef __CSTR_H__
#define __CSTR_H__

struct cstr
{
    char *str;
    size_t length;  /* allocated space. e.g.: "abc" + '\0' */
};
typedef struct cstr cstr_t;

cstr_t *cstr_new(const char *str);
void cstr_del(cstr_t *thiz);

cstr_t *cstr_cat(cstr_t *thiz, const char *src);
cstr_t *cstr_ncat(cstr_t *thiz, const char *src, size_t n);

cstr_t *cstr_precat(cstr_t *thiz, const char *src);
cstr_t *cstr_prencat(cstr_t *thiz, const char *src, size_t n);

cstr_t *cstr_cat_cstr(cstr_t *dst, cstr_t *src);
cstr_t *cstr_ncat_cstr(cstr_t *dst, cstr_t *src, size_t n);

cstr_t *cstr_precat_cstr(cstr_t *dst, cstr_t *src);
cstr_t *cstr_prencat_cstr(cstr_t *dst, cstr_t *src, size_t n);

int cstr_cmp(cstr_t *const cstr1, cstr_t *const cstr2);
int cstr_ncmp(cstr_t *const cstr1, cstr_t *const cstr2, size_t n);

int cstr_casecmp(cstr_t *const cstr1, cstr_t *const cstr2);
int cstr_strlen(cstr_t *const thiz);

cstr_t *cstr_sprintf(cstr_t *thiz, const char *fmt, ...);
cstr_t *cstr_append_printf(cstr_t *thiz, const char *format, ...);
#endif /* __CSTR_H__ */
