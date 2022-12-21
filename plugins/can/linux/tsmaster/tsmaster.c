#include <stddef.h>
#include <stdio.h>
#include <string.h>
#include "libusb.h"
#include "tsmaster.h"
#include "kernel.h"


struct can_device_ops tsmaster_device_ops;
static on_recv_fun_t _on_recv = NULL;
static on_canfd_recv_fun_t _on_canfd_recv = NULL;

const int timing_table[16] = {
    5, //KBPS_5 = 
    10, //KBPS_10,
    20, //KBPS_20,
    40, //KBPS_40,
    50, //KBPS_50,
    80, //KBPS_80,
    100, //KBPS_100,
    125, //KBPS_125,
    200, //KBPS_200,
    250, //KBPS_250,
    400, //KBPS_400,
    500, //KBPS_500,
    666, //KBPS_666,
    800, //KBPS_800,
    1000, //KBPS_1000
    2000, //KBPS_2000
};

static const struct tsmaster_device default_tsmaster_device = {
    .name = TSMASTER_NAME,
    .device = {
        .name = TSMASTER_NAME,
        .support_canfd = true,
	    .bittiming = {
            .bitrate = KBPS_500
        },
	    .data_bittiming = {
            .bitrate = KBPS_2000
        },
        .ops = &tsmaster_device_ops,
    },
    .ADeviceHandle = 0,
};

static bool is_serials_equal(char *s1, char *s2) {
    for(int i = 0; i < 12; ++i) {
        if(s1[i] != s2[i]) return false;
    }
    return true;
}

static can_frame_t* calloc_can_frame_from_t_lib_can(const TLibCAN* pObj, size_t len) {
    can_frame_t* frames = malloc(sizeof(struct can_frame_s) * len);
    memset(frames, 0, sizeof(struct can_frame_s) * len);
    can_frame_t* p = frames;
    for(int i = 0; i < len; ++i,++p,++pObj) {
        p->can_id = pObj->FIdentifier;
        p->can_dlc = pObj->FDLC;
        memcpy(p->data, pObj->FData.d, 8);
    }
    return frames;
}
static canfd_frame_t* calloc_canfd_frame_from_t_lib_can(const TLibCANFD* pObj, size_t len) {
    printf("%s in len:%d\n ", __func__, len);
    canfd_frame_t* frames = malloc(sizeof(struct canfd_frame_s) * len);
    memset(frames, 0, sizeof(struct canfd_frame_s) * len);
    canfd_frame_t* p = frames;
    for(int i = 0; i < len; ++i,++p,++pObj) {
        p->can_id = pObj->FIdentifier;
        p->can_dlc = pObj->FDLC;
        printf("%s i:%d   id: %x \n ", __func__, i, p->can_id);
        memcpy(p->data, pObj->FData.d, 64);
    }
    return frames;
}

static TLibCAN* calloc_t_lib_can_from_can_frame(can_frame_t* frames, size_t len) {
    TLibCAN* pObj = malloc(sizeof(TLibCAN) * len);
    memset(pObj, 0, sizeof(TLibCAN) * len);
    TLibCAN* p = pObj;
    for(int i = 0; i < len; ++i,++p,++frames) {
        p->FIdentifier = frames->can_id;
        p->FDLC = frames->can_dlc ;
        p->FProperties.bits.remoteframe = 0x00; //not remote frame,standard frame
        p->FProperties.bits.extframe = 0;
        p->FIdxChn = CHN1;
        memcpy(p->FData.d, frames->data, 8);
    }
    return pObj;
}

static TLibCANFD* calloc_t_lib_canfd_from_can_frame(canfd_frame_t* frames, size_t len) {
    printf("%s in len:%d\n ", __func__, len);
    TLibCANFD* pObj = malloc(sizeof(TLibCANFD) * len);
    memset(pObj, 0, sizeof(TLibCANFD) * len);
    TLibCANFD* p = pObj;
    for(int i = 0; i < len; ++i,++p,++frames) {
        printf("%s i:%d   id: %x \n ", __func__, i, frames->can_id);
        p->FIdentifier = frames->can_id;
        p->FDLC = frames->can_dlc ;
        p->FProperties.bits.remoteframe = 0x00; //not remote frame,standard frame
        p->FProperties.bits.extframe = 0;
        p->FIdxChn = CHN1;
        p->FFDProperties.bits.EDL = 1; //FDMode
        p->FFDProperties.bits.BRS = 1;  //Open baudrate speed
        memcpy(p->FData.d, frames->data, 64);
    }
    return pObj;
}

static void sync_canfd_bittiming(struct tsmaster_device *tdev) {
    tscan_config_can_by_baudrate(tdev->ADeviceHandle, CHN1, timing_table[tdev->device.bittiming.bitrate], 1);
    tscan_config_canfd_by_baudrate(tdev->ADeviceHandle, CHN1, timing_table[tdev->device.bittiming.bitrate], timing_table[tdev->device.data_bittiming.bitrate], lfdtISOCAN, lfdmNormal,1);

    tscan_config_can_by_baudrate(tdev->ADeviceHandle, CHN2, timing_table[tdev->device.bittiming.bitrate], 1);
    tscan_config_canfd_by_baudrate(tdev->ADeviceHandle, CHN2, timing_table[tdev->device.bittiming.bitrate], timing_table[tdev->device.data_bittiming.bitrate], lfdtISOCAN, lfdmNormal,1);
}

static int tsmaster_set_bittiming(struct can_device *dev, enum BAUDRATE baudrate) {
    printf("%s start\n", __func__);

    struct tsmaster_device *tdev = container_of((void *)dev,
			struct tsmaster_device, device);
    dev->bittiming.bitrate = baudrate;
    sync_canfd_bittiming(tdev);
}

static int tsmaster_set_data_bittiming(struct can_device *dev, enum BAUDRATE baudrate) {
    printf("%s start\n", __func__);
    struct tsmaster_device *tdev = container_of((void *)dev,
			struct tsmaster_device, device);
    dev->data_bittiming.bitrate = baudrate;
    sync_canfd_bittiming(tdev);
}

static int tsmaster_set_receive_listener(struct can_device *dev, on_recv_fun_t on_recv) {
    printf("%s start\n", __func__);
    _on_recv  = on_recv;
}

static int tsmaster_set_canfd_receive_listener(struct can_device *dev, on_canfd_recv_fun_t on_recv) {
    printf("%s start\n", __func__);
    _on_canfd_recv = on_recv;
}

static bool tsmaster_send(struct can_device * dev, can_frame_t *frames, unsigned int len) {
    printf("%s start\n", __func__);

    TLibCAN* pObj = calloc_t_lib_can_from_can_frame(frames, len);
    TLibCAN* p = pObj;
    struct tsmaster_device *tdev = container_of((void *)dev,
			struct tsmaster_device, device);
    uint32_t result = 0;
    for(int i = 0; i < len; ++i, p++) {
        result = tscan_transmit_can_async(tdev->ADeviceHandle, p);
    }
    free(pObj);
    return true;
}

static bool tsmaster_sendfd(struct can_device * dev, canfd_frame_t *frames, unsigned int len) {
    printf("%s start, len: %u\n", __func__, len);
    TLibCANFD* pObj = calloc_t_lib_canfd_from_can_frame(frames, len);
    TLibCANFD* p = pObj;
    struct tsmaster_device *tdev = container_of((void *)dev,
			struct tsmaster_device, device);
    uint32_t result = 0;

    result = tscan_transmit_canfd_sync(tdev->ADeviceHandle, p, 10);
    // for(int i = 0; i < len; ++i, p++) {
    //     result = tscan_transmit_canfd_sync(tdev->ADeviceHandle, p, 10);
    // }
    free(pObj);
    return true;
}

int tsmaster_driver_probe(struct can_device *dev) {
    printf("%s start\n", __func__);

    // uint32_t deviceCount;
    // initialize_lib_tscan(true,false,false);  //Intialization of libTSCAN Library
    //                                          //
    // tscan_scan_devices(&deviceCount); 
    // printf("%s after scan , %d devices found.\n", __func__, deviceCount);

    return 0;
}
int tsmaster_driver_remove(struct can_device *dev) {
    printf("%s start\n", __func__);
    return 0;
}

#include <unistd.h>
#include <sys/mman.h>
#define PAGE_START(P) ((uintptr_t)(P) & ~(pagesize-1))
#define PAGE_END(P)   (((uintptr_t)(P) + pagesize - 1) & ~(pagesize-1))
/**
 * 柯理化 wrap device pointer
 * 仅在 x86_64 system v abi  系统下可用 ，因为直接操作寄存器了
 */
uint8_t * curry_one_param_device_func(
    void *two_param_func, 
    struct can_device* dev)
{
    printf("%s in  dev addr: %p \n", __func__, dev);
    uintptr_t fp = (uintptr_t)two_param_func;
    uint8_t template[] = {
        0x48, 0xbe, 0, 0, 0, 0, 0, 0, 0, 0,                 /* movq $imm64,%rsi */
        0x48, 0xb8, fp >>  0, fp >>  8, fp >> 16, fp >> 24, /* movq fp, %rax */
                    fp >> 32, fp >> 40, fp >> 48, fp >> 56,
        0xff, 0xe0                                          /* jmpq *%rax */
    };
    
    uint8_t *buf = malloc(sizeof(template));
    if (!buf)
        return NULL;
    
    memcpy(buf, template, sizeof(template));
    uintptr_t second_param = (uintptr_t)dev;
    buf[2] = second_param >> 0;
    buf[3] = second_param >> 8;
    buf[4] = second_param >> 16;
    buf[5] = second_param >> 24;
    buf[6] = second_param >> 32;
    buf[7] = second_param >> 40;
    
    uintptr_t pagesize = sysconf(_SC_PAGE_SIZE);
    mprotect((void *)PAGE_START(buf),
             PAGE_END(buf + sizeof(template)) - PAGE_START(buf),
             PROT_READ|PROT_WRITE|PROT_EXEC);
    
    return buf;
}


static void receive_can_message(const TLibCAN* aData, struct can_device* dev) {
    printf("%s in ,  can id: %u", __func__, aData->FIdentifier);

    if(_on_recv && aData->FProperties.bits.istx == false && aData->FProperties.bits.iserrorframe == false) {
        can_frame_t * frames = calloc_can_frame_from_t_lib_can(aData, 1);
        _on_recv(dev->uuid, frames, 1);
        free(frames);
    }
}

static void receive_canfd_message(const TLibCANFD* aData, struct can_device* dev) {
    if(_on_canfd_recv && aData->FProperties.bits.istx == false && aData->FProperties.bits.iserrorframe == false) {
        canfd_frame_t * frames = calloc_canfd_frame_from_t_lib_can(aData, 1);
        printf("receive_canfd_message id:%x\n", frames->can_id);
        _on_canfd_recv(dev->uuid, frames, 1);
        free(frames);
    }
}

typedef void (*can_callback_t)(const TLibCAN* aData, struct can_device* dev);
typedef void (*canfd_callback_t)(const TLibCANFD* aData, struct can_device* dev);

static void canfd_test(const TLibCANFD * aData) {
    printf("%s in ,  can id: %u\n", __func__, aData->FIdentifier);
}

static uint32_t deviceCount;
static int /*__init*/ tsmaster_driver_init(void) 
{
    // memset(uuid, 0, sizeof(uuid));
    printf("%s start\n", __func__);

    initialize_lib_tscan(true,false,false);  //Intialization of libTSCAN Library
                                             //
    tscan_scan_devices(&deviceCount); 
    printf("%s after scan , %d devices found.\n", __func__, deviceCount);

    for(uint32_t i = 0; i < deviceCount; i++)
    {
        struct tsmaster_device * tdevice = (struct tsmaster_device *)malloc(sizeof(struct tsmaster_device));
        memcpy(tdevice, &default_tsmaster_device, sizeof(default_tsmaster_device) );
        tscan_get_device_info(
          i,
          &tdevice->AFManufacturer,
          &tdevice->AFProduct,
          &tdevice->AFSerial
          );
        printf("Manufacturer:%s\n", tdevice->AFManufacturer);
        printf("Product No:%s\n", tdevice->AFProduct);
        printf("Serial No:%s\n", tdevice->AFSerial);

        size_t sizeuuid = sizeof(TSMASTER_NAME) + sizeof(tdevice->AFSerial) + 1;
        snprintf(tdevice->device.uuid, sizeuuid, "%s-%s", TSMASTER_NAME, tdevice->AFSerial);

        uint64_t retValue = tscan_connect(tdevice->AFSerial, &tdevice->ADeviceHandle); //Connect the appointted device with serial no string: AFSerial
        printf("tsmaster connect result: %ld\n", retValue);
                                                                                       //
        if ((retValue == 0) || (retValue == 5))   //0:success; 5: isconnectted
        {

            printf("%s  ,  dev addr: %p\n", __func__, &tdevice->device);

            sync_canfd_bittiming(tdevice);

            TCANQueueEvent_Win32_t can_listener = (TCANQueueEvent_Win32_t)curry_one_param_device_func(receive_can_message, &tdevice->device);
            TCANFDQueueEvent_Win32_t canfd_listener = (TCANFDQueueEvent_Win32_t)curry_one_param_device_func(receive_canfd_message, &tdevice->device);
            retValue = tscan_register_event_can(tdevice->ADeviceHandle, can_listener);
            retValue = tscan_register_event_canfd(tdevice->ADeviceHandle, canfd_listener);
            add_device(&tdevice->device);
        } else {
            char err[255];
            tscan_get_error_description(retValue, &err);
            printf("*** tsmaster device connect error!  ret:%lu, detail: %s***\n", retValue, err);
        }

    }
    
    return 0;
}


static void tsmaster_driver_exit(void)
{
    printf("%s start\n", __func__);
}
// module_exit(driver_tsmaster_exit);

struct can_device_ops tsmaster_device_ops = {
    .set_bittiming = tsmaster_set_bittiming,
	.set_data_bittiming = tsmaster_set_data_bittiming,
	.set_receive_listener = tsmaster_set_receive_listener,//)struct can_device *, int (*on_receive)(struct can_frame_s *, unsigned int num))
    .set_canfd_receive_listener = tsmaster_set_canfd_receive_listener,
    .send = tsmaster_send,
    .sendfd = tsmaster_sendfd,
};

static const struct usb_device_id device_table[] = {
    { USB_DEVICE(0x5453, 0x0001) },
	{}/* terminating entry */
};

static struct usb_can_driver tsmaster_can_driver = {
    .init     = tsmaster_driver_init,
    .exit     = tsmaster_driver_exit,
    .probe    = tsmaster_driver_probe,
    .remove   = tsmaster_driver_remove,
	.id_table = device_table,
    .name	= "tsmaster",
};

module_usb_driver(tsmaster_can_driver);
