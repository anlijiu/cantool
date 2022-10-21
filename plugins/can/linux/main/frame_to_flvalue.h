#ifndef __FRAME_TO_FLVALUE_H__
#define __FRAME_TO_FLVALUE_H__

#include <flutter_linux/flutter_linux.h>
#include "can_defs.h"


FlValue* can_frame_to_flvalue(struct can_frame_s *frame, unsigned int num);

FlValue* canfd_frame_to_flvalue(struct canfd_frame_s *frame, unsigned int num);


#endif//__FRAME_TO_FLVALUE_H__
