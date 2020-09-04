#pragma once
#include <stdint.h>
#define CAN_TICK_TIME 10


struct message_meta {
    uint32_t id;
    unsigned char length;
    char name[255];
    list_t * signal_ids = NULL;
};

enum ByteOrder {
    kBigEndian = 0,
    kLittleEndian,
};

struct signal_meta {
    char name[255];
    uint32_t start_bit;
    uint32_t length;
    ByteOrder order;
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
