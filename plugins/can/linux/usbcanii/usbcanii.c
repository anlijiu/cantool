#include <stddef.h>
#include <unistd.h>
#include <stdio.h>
#include <string.h>
#include "libusb.h"
#include "kernel.h"
#include "usbcanii.h"

struct can_device_ops usbcanii_device_ops;
// static int (*notify_listener)(struct can_frame_s *, unsigned int num) = NULL;
static on_recv_fun_t _on_recv = NULL;

// static char uuid[4][40];
// static const char *driver_name = "usbcanii";
const int timing_table[16][2] = {
    { 0xBF, 0xFF }, //KBPS_5 = 
    { 0x31, 0x1C }, //KBPS_10,
    { 0x18, 0x1C }, //KBPS_20,
    { 0x87, 0xFF }, //KBPS_40,
    { 0x09, 0x1C }, //KBPS_50,
    { 0x83, 0Xff }, //KBPS_80,
    { 0x04, 0x1C }, //KBPS_100,
    { 0x03, 0x1C }, //KBPS_125,
    { 0x81, 0xFA }, //KBPS_200,
    { 0x01, 0x1C }, //KBPS_250,
    { 0x80, 0xFA }, //KBPS_400,
    { 0x00, 0x1C }, //KBPS_500,
    { 0x80, 0xB6 }, //KBPS_666,
    { 0x00, 0x16 }, //KBPS_800,
    { 0x00, 0x14 }, //KBPS_1000
    { 0x00, 0x14 }  //KBPS_2000
};

void printCharArray(uint8_t* arr, size_t len) {
    for(long i = 0; i < len; ++i) {
      printf(" \%02hhx ", arr[i]);
    }
}

static const struct usbcanii_device default_usbcanii_device = {
    // .name = driver_name,
    // .name = "usbcanii",
    .name = USBCANII_NAME,
    .idx = 0,
    .serial = { '\0' },
    .device = {
        .name = USBCANII_NAME,
        .support_canfd = false,
	    .bittiming = {
            .bitrate = KBPS_500
        },
        .ops = &usbcanii_device_ops,
    },
    .ports = {
        {
            .inited = false,
            .conf =  {
                .AccCode = 0x80000008,
                .AccMask = 0xFFFFFFFF,
                .Filter = 1,//receive all frames
                .Timing0 = 0x00,
                .Timing1 = 0x1C,//baudrate 500kbps
                .Mode = 0,//normal mode
            }
        },
        {
            .inited = false,
            .conf =  {
                .AccCode = 0x80000008,
                .AccMask = 0xFFFFFFFF,
                .Filter = 1,//receive all frames
                .Timing0 = 0x00,
                .Timing1 = 0x1C,//baudrate 500kbps
                .Mode = 0,//normal mode
            }
        }
    },
};

static bool is_serials_equal(char *s1, char *s2) {
    for(int i = 0; i < 3; ++i) {
        if(s1[i] != s2[i]) return false;
    }
    return true;
}

static int usbcanii_set_bittiming(struct can_device *dev, enum BAUDRATE baudrate) {

    struct usbcanii_device *udev = container_of((void *)dev,
			struct usbcanii_device, device);
    udev->device.bittiming.bitrate = baudrate;
    for(int i = 0; i < 2; ++i) {
        udev->ports[i].conf.Timing0 = timing_table[baudrate][0];
        udev->ports[i].conf.Timing1 = timing_table[baudrate][1];
        VCI_InitCAN(USB_CAN_DEVICE_TYPE, udev->idx, i, &udev->ports[i].conf);
    }
    printf("%s start\n", __func__);
}

// typedef struct can_frame_s {
// 	uint16_t can_id;
// 	uint8_t can_dlc;
// 	uint8_t data[CAN_FRAME_MAX_DATA_LEN];
// } __attribute__((packed)) can_frame_t;

static can_frame_t* calloc_can_frame_from_vci_can_obj(PVCI_CAN_OBJ pObj, size_t len) {
    can_frame_t* frames = malloc(sizeof(struct can_frame_s) * len);
    can_frame_t* p = frames;
    for(int i = 0; i < len; ++i,++p,++pObj) {
        p->can_id = pObj->ID;
        p->can_dlc = pObj->DataLen;
        memcpy(p->data, pObj->Data, 8);
    }
    return frames;
}

static PVCI_CAN_OBJ calloc_vci_can_obj_from_can_frame(can_frame_t* frames, size_t len) {
    PVCI_CAN_OBJ pObj = malloc(sizeof(VCI_CAN_OBJ) * len);
    PVCI_CAN_OBJ p = pObj;
    for(int i = 0; i < len; ++i,++p,++frames) {
        p->ID = frames->can_id;
        p->DataLen = frames->can_dlc ;
        memcpy(p->Data, frames->data, 8);
    }
    return pObj;
}

static void *can_receive_func(void *param) {
    struct usbcanii_device *udev = (struct usbcanii_device *)param;
    unsigned int cache_len = 100;
    VCI_CAN_OBJ can0_cache[cache_len];
    VCI_CAN_OBJ can1_cache[cache_len];

    int msg_num = 0;
    int receive_len = 0;
    VCI_ERR_INFO vciErrorInfo;
    while(true) {
        if(_on_recv) {
	        // msg_num = VCI_GetReceiveNum(USB_CAN_DEVICE_TYPE, udev->idx, 0);
            // printf("%s received %d frames \n", __func__, msg_num );
            // if(msg_num > 0) {
                // PVCI_CAN_OBJ pObj = malloc(sizeof(VCI_CAN_OBJ) * msg_num);
                memset(can0_cache, 0, cache_len * sizeof(VCI_CAN_OBJ));
                // 也可以这样memset(&can0_cache, 0, sizeof can0_cache);
                receive_len = VCI_Receive(USB_CAN_DEVICE_TYPE, udev->idx, 0, can0_cache, cache_len, 20);
                printf("%s received %d frames.  device type: %d,  idx: %d \n", __func__, receive_len, USB_CAN_DEVICE_TYPE, udev->idx );
                if(receive_len < 0) {
                    int errCode = VCI_ReadErrInfo(USB_CAN_DEVICE_TYPE, udev->idx, 0, &vciErrorInfo);
                    printf("usbcanii device idx:%d,port:%d read error! errno:%d\n", udev->idx, 0, errCode);
                } else if(receive_len > 0) {
                    can_frame_t * frames = calloc_can_frame_from_vci_can_obj(can0_cache, receive_len);
                    _on_recv(udev->device.uuid, frames, receive_len);
                    free(frames);
                }
                // free(pObj); 

                usleep(10000);// 10000ns = 10ms;
            // } else {
            //     usleep(1000000);// 1000000ns = 1000ms = 1s;
            // }
        }
    }
}

static int usbcanii_set_data_bittiming(struct can_device *dev, enum BAUDRATE baudrate) {
    printf("%s start\n", __func__);
}

// int (*on_receive)(struct can_frame_s *, unsigned int num)) 
static int usbcanii_set_receive_listener(struct can_device *dev, on_recv_fun_t onrecv) {
    _on_recv = onrecv;
}

static bool usbcanii_send(struct can_device * dev, can_frame_t *frames, unsigned int len) {
    printf("%s start\n", __func__);

    PVCI_CAN_OBJ pObj = calloc_vci_can_obj_from_can_frame(frames, len);
    struct usbcanii_device *udev = container_of((void *)dev,
			struct usbcanii_device, device);
    int send_len = VCI_Transmit(USB_CAN_DEVICE_TYPE, udev->idx, 0, pObj, len);

    printCharArray(pObj->Data, 8);
    free(pObj);
    printf("usb_can_ops_send  deviceIdx: %d, len: %d, send_len:%d\n", udev->idx, len, send_len);
    return send_len == len;
}

int usbcanii_driver_probe(struct can_device *dev) {
    printf("%s start\n", __func__);
    return 0;
}
int usbcanii_driver_remove(struct can_device * dev) {
    printf("%s start\n", __func__);

    struct usbcanii_device *udev = container_of((void *)dev,
			struct usbcanii_device, device);
    remove_device(dev);
    free(udev);
    // remove_device(&udevice->device);
    return 0;
}

static const VCI_INIT_CONFIG default_vci_config = {
    .AccCode = 0x80000008,
    .AccMask = 0xFFFFFFFF,
    .Filter = 1,//receive all frames
    .Timing0 = 0x00,
    .Timing1 = 0x1C,//baudrate 500kbps
    .Mode = 0,//normal mode
};
static VCI_BOARD_INFO1 boardInfo;
static unsigned int deviceCount;

static void printf_VCI_INIT_CONFIG(VCI_INIT_CONFIG * config) {
    printf("AccCode %#x, ", config->AccCode);
    printf("Timing0 %#x, ", config->Timing0);
    printf("Timing1 %#x \n", config->Timing1);
} 
// module_init(driver_usbcanii_init);
static int /*__init*/ usbcanii_driver_init(void) 
{
    // memset(uuid, 0, sizeof(uuid));
    printf("%s start\n", __func__);
    deviceCount = VCI_FindUsbDevice(&boardInfo);
    for(int i = 0; i < deviceCount; ++i) {
        struct usbcanii_device * udevice = (struct usbcanii_device *)malloc(sizeof(struct usbcanii_device));
        memcpy(udevice, &default_usbcanii_device, sizeof(default_usbcanii_device) );
        udevice->idx = i;

        size_t sizeuuid = sizeof(USBCANII_NAME) + sizeof(boardInfo.str_Usb_Serial[i]) + 1;
        snprintf(udevice->device.uuid, sizeuuid, "%s-%s", USBCANII_NAME, boardInfo.str_Usb_Serial[i]);
        printf("%s ,   uuid:%s\n", __func__, udevice->device.uuid);

        unsigned int open_result = VCI_OpenDevice(USB_CAN_DEVICE_TYPE, i, 0);
        if(open_result != 1) {
            printf("VCI_OpenDevice %s device %d failed ,  result: %d \n", udevice->device.uuid, i, open_result);
            // continue;
        }
        // memcpy(uuid[i], udevice->device.uuid, sizeuuid);
        for(int port_idx = 0; port_idx < USB_CAN_PORT_COUNT; port_idx++) {
            memcpy(&udevice->ports[port_idx].conf, &default_vci_config, sizeof(default_vci_config));
            bool result = (VCI_InitCAN(USB_CAN_DEVICE_TYPE, i, port_idx, &udevice->ports[port_idx].conf)==1);
            result = (VCI_StartCAN(USB_CAN_DEVICE_TYPE, i, port_idx)==1);
            udevice->ports[port_idx].inited = result;
            printf("VCI_InitCAN %s device %d ,port_idx:%d,  result :%s\n", udevice->device.uuid, i, port_idx, result ? "true" : "false");
            printf_VCI_INIT_CONFIG(&udevice->ports[port_idx].conf);
        }
        int err = pthread_create(&udevice->recv_thread, NULL, &can_receive_func, udevice);
        pthread_detach(udevice->recv_thread);
        add_device(&udevice->device);
    }
    printf("%s end\n", __func__);
    return 0;
}

// module_exit(driver_usbcanii_exit);
static void /*__exit*/ usbcanii_driver_exit(void)
{
    printf("%s start\n", __func__);
}

struct can_device_ops usbcanii_device_ops = {
    .set_bittiming = usbcanii_set_bittiming,
	.set_data_bittiming = usbcanii_set_data_bittiming,
	.set_receive_listener = usbcanii_set_receive_listener,//)struct can_device *, int (*on_receive)(struct can_frame_s *, unsigned int num))
    .send = usbcanii_send,//(struct can_device *, unsigned int, can_frame_t, unsigned int);
};

static const struct usb_device_id device_table[] = {
    { USB_DEVICE(0x04d8, 0x0053) },
	{}/* terminating entry */
};

static struct usb_can_driver usbcanii_can_driver = {
    .init     = usbcanii_driver_init,
    .exit     = usbcanii_driver_exit,
    .probe    = usbcanii_driver_probe,
    .remove   = usbcanii_driver_remove,
	.id_table = device_table,
    .name	= "usbcanii",
};

module_usb_driver(usbcanii_can_driver);
