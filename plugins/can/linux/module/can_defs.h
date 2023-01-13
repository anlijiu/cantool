#pragma once

#include <stdint.h>
#include <stdbool.h>
#include "list/list.h"
#define CAN_TICK_TIME 10

#define CAN_FRAME_MAX_DATA_LEN 8
#define CANFD_FRAME_MAX_DATA_LEN 64

#ifdef __cplusplus
extern "C" {
#endif

enum BAUDRATE {
	KBPS_5 = 0,
	KBPS_10,
	KBPS_20,
	KBPS_40,
	KBPS_50,
	KBPS_80,
	KBPS_100,
	KBPS_125,
	KBPS_200,
	KBPS_250,
	KBPS_400,
	KBPS_500,//11
	KBPS_666,
	KBPS_800,
	KBPS_1000,
	KBPS_2000//15
};

struct can_bittiming {
	enum BAUDRATE bitrate;		/* Bit-rate in bits/second */
};

typedef struct can_frame_s {
	uint16_t can_id;
	uint8_t can_dlc;
	uint8_t data[CAN_FRAME_MAX_DATA_LEN];
} __attribute__((packed)) can_frame_t;

typedef struct canfd_frame_s {
	uint16_t can_id;
	uint8_t can_dlc;
	uint8_t data[CANFD_FRAME_MAX_DATA_LEN];
} __attribute__((packed)) canfd_frame_t;

struct message_meta {
    uint32_t id;
    unsigned char length;
    char name[255];
    list_t * signal_ids;
};

enum ByteOrder {
    kBigEndian = 0,
    kLittleEndian,
};

struct signal_meta {
    char name[255];
    uint32_t start_bit;
    uint32_t length;
    enum ByteOrder order;
    double scaling;
    double offset;
    double minimum;
    double maximum;
    bool is_signed;
    char unit[10];
    uint32_t mid;
};

typedef enum
{
    AMMO_TRANSFORM_CONST,
    AMMO_TRANSFORM_SIN,
    AMMO_TRANSFORM_COS,
    AMMO_TRANSFORM_TAN,
    AMMO_TRANSFORM_COT
} e_signal_transform_type;


typedef struct signal_assembler {
    char signal_name[255];
    double raw_value;
    e_signal_transform_type transform_type;
    struct signal_meta * meta;
} signal_assembler;

typedef struct message_assembler {
    uint32_t id;
    struct message_meta * meta;
} message_assembler;

#ifdef __cplusplus
}
#endif
