#ifndef __LIBTSCAN_H
#define __LIBTSCAN_H

#include <stdint.h>
#include <stddef.h>

#pragma   pack(1)
typedef uint8_t u8;
typedef uint8_t byte;
typedef int8_t s8;
typedef uint16_t u16;
typedef int16_t s16;
typedef uint32_t u32;
typedef int32_t s32;
typedef uint64_t u64;
typedef int64_t s64;
typedef wchar_t wchar;
typedef struct _u8x8 { u8 d[8]; } u8x8;
typedef struct _u8x64 { u8 d[64]; } u8x64;



typedef enum
{
	CHN1,
	CHN2,
	CHN3,
	CHN4,
	CHN5,
	CHN6,
	CHN7,
	CHN8,
	CHN9,
	CHN10,
	CHN11,
	CHN12,
	CHN13,
	CHN14,
	CHN15,
	CHN16,
	CHN17,
	CHN18,
	CHN19,
	CHN20,
	CHN21,
	CHN22,
	CHN23,
	CHN24,
	CHN25,
	CHN26,
	CHN27,
	CHN28,
	CHN29,
	CHN30,
	CHN31,
	CHN32
}APP_CHANNEL;


typedef enum
{ lfdtCAN = 0, 
  lfdtISOCAN = 1, 
  lfdtNonISOCAN = 2
}TLIBCANFDControllerType;

typedef enum
{
	lfdmNormal = 0, 
	lfdmACKOff = 1, 
	lfdmRestricted = 2
}TLIBCANFDControllerMode;


typedef enum
{
	ONLY_RX_MESSAGES,  //只读取接收的数据
	TX_RX_MESSAGES     //发送出去和接收的数据都读取出来
}READ_TX_RX_DEF;

typedef union {
	u8 value;
	struct {
		u8 istx : 1;
		u8 remoteframe : 1;
		u8 extframe : 1;
		u8 tbd : 4;
		u8 iserrorframe : 1;
	}bits;
}TCANProperty;

//typedef struct _TCAN {
//	u8 FIdxChn;           // channel index starting from 0
//	TCANProperty FProperties;       // default 0, masked status:
//						  // [7] 0-normal frame, 1-error frame
//						  // [6-3] tbd
//						  // [2] 0-std frame, 1-extended frame
//						  // [1] 0-data frame, 1-remote frame
//						  // [0] dir: 0-RX, 1-TX
//	u8 FDLC;              // dlc from 0 to 8
//	u8 FReserved;         // reserved to keep alignment
//	s32 FIdentifier;      // CAN identifier
//	u64 FTimeUS;          // timestamp in us  //Modified by Eric 0321
//	u8x8 FData;           // 8 data bytes to send
//} TCAN;

typedef struct _TLibCAN {
	u8 FIdxChn;           // channel index starting from 0
	TCANProperty FProperties;       // default 0, masked status:
						  // [7] 0-normal frame, 1-error frame
						  // [6-3] tbd
						  // [2] 0-std frame, 1-extended frame
						  // [1] 0-data frame, 1-remote frame
						  // [0] dir: 0-RX, 1-TX
	u8 FDLC;              // dlc from 0 to 8
	u8 FReserved;         // reserved to keep alignment
	s32 FIdentifier;      // CAN identifier
	u64 FTimeUS;          // timestamp in us  //Modified by Eric 0321
	u8x8 FData;           // 8 data bytes to send
} TLibCAN,*PLibCAN;


typedef union {
	u8 value;
	struct {
		u8 EDL : 1;
		u8 BRS : 1;
		u8 ESI : 1;
		u8 tbd : 5;
	}bits;
}TCANFDProperty;
// CAN FD frame definition = 80 B
  // CAN FD frame definition = 80 B
typedef struct _TLibCANFD {
	u8 FIdxChn;           // channel index starting from 0        = CAN
	TCANProperty FProperties;       // default 0, masked status:            = CAN
						   // [7] 0-normal frame, 1-error frame
						   // [6] 0-not logged, 1-already logged
						   // [5-3] tbd
						   // [2] 0-std frame, 1-extended frame
						   // [1] 0-data frame, 1-remote frame
						   // [0] dir: 0-RX, 1-TX
	u8 FDLC;              // dlc from 0 to 15                     = CAN
	TCANFDProperty FFDProperties;      // [7-3] tbd                            <> CAN
						   // [2] ESI, The E RROR S TATE I NDICATOR (ESI) flag is transmitted dominant by error active nodes, recessive by error passive nodes. ESI does not exist in CAN format frames
						   // [1] BRS, If the bit is transmitted recessive, the bit rate is switched from the standard bit rate of the A RBITRATION P HASE to the preconfigured alternate bit rate of the D ATA P HASE . If it is transmitted dominant, the bit rate is not switched. BRS does not exist in CAN format frames.
						   // [0] EDL: 0-normal CAN frame, 1-FD frame, added 2020-02-12, The E XTENDED D ATA L ENGTH (EDL) bit is recessive. It only exists in CAN FD format frames
	s32  FIdentifier;      // CAN identifier                       = CAN
	u64 FTimeUS;          // timestamp in us                      = CAN
    u8x64 FData;          // 64 data bytes to send                <> CAN
}TLibCANFD, * PLibCANFD;

typedef union
{
	u8 value;
	struct {
		u8 istx : 1;
		u8 breaksended : 1;
		u8 breakreceived : 1;
		u8 syncreceived : 1;
		u8 hwtype : 2;
		u8 isLogged : 1;
		u8 iserrorframe : 1;
	}bits;
}TLINProperty;
typedef struct _TLIN {
	u8 FIdxChn;           // channel index starting from 0
	u8 FErrCode;          //  0: normal
	TLINProperty FProperties;       // default 0, masked status:
						   // [7] tbd
						   // [6] 0-not logged, 1-already logged
						   // [5-4] FHWType //DEV_MASTER,DEV_SLAVE,DEV_LISTENER
						   // [3] 0-not ReceivedSync, 1- ReceivedSync
						   // [2] 0-not received FReceiveBreak, 1-Received Break
						   // [1] 0-not send FReceiveBreak, 1-send Break
						   // [0] dir: 0-RX, 1-TX
	u8 FDLC;              // dlc from 0 to 8
	u8 FIdentifier;       // LIN identifier:0--64
	u8 FChecksum;         // LIN checksum
	u8 FStatus;           // place holder 1
	u64 FTimeUS;          // timestamp in us  //Modified by Eric 0321
	u8x8 FData;           // 8 data bytes to send
}TLibLIN, *PLibLIN;

typedef enum
{
	LIN_Protocol_13,
	LIN_Protocol_20,
	LIN_Protocol_21,
	LIN_Protocol_J2602
}TLINProtocol;

typedef enum
{
	MasterNode,
	SlaveNode,
	MonitorNode
}TLIN_FUNCTION_TYPE;
//function pointer type
//Device connectted event
typedef void(* TTSCANConnectedCallback_t)(const size_t ADevicehandle);
//Device disconnected event
typedef void(* TTSCANDisConnectedCallback_t)(const size_t ADevicehandle);
//High precise timer event
typedef void(* THighResTimerCallback_t)(const u32 ADevicehandle);
//CAN Msg Received Event
typedef void(* TCANQueueEvent_Win32_t)(const TLibCAN* AData);
//LIN Msg Received Event
typedef void(* TLINQueueEvent_Win32_t)(const TLibLIN* AData);
//CANFD Msg Received Event
typedef void(* TCANFDQueueEvent_Win32_t)(const TLibCANFD* AData);


#ifdef __cplusplus
extern "C" {
#endif

//Register callback functions
//Register CAN message received event
u32 tscan_register_event_can(const size_t ADeviceHandle, const TCANQueueEvent_Win32_t ACallback);
//unregister CAN message received event
u32 tscan_unregister_event_can(const size_t ADeviceHandle, const TCANQueueEvent_Win32_t ACallback);

//Register CANFD message received event
u32 tscan_register_event_canfd(const size_t ADeviceHandle, const TCANFDQueueEvent_Win32_t ACallback);
//UnRegister CAN message received event
u32 tscan_unregister_event_canfd(const size_t ADeviceHandle, const TCANFDQueueEvent_Win32_t ACallback);


//Register LIN message received event
u32 tslin_register_event_lin(const size_t ADeviceHandle, const TLINQueueEvent_Win32_t ACallback);
//UnRegister LIN message received event
u32 tslin_unregister_event_lin(const size_t ADeviceHandle, const TLINQueueEvent_Win32_t ACallback);

//Register FastLIN message received event
u32 tscan_register_event_fastlin(const size_t ADeviceHandle, const TLINQueueEvent_Win32_t ACallback);
//UnRegister FastLIN message received event
u32 tscan_unregister_event_fastlin(const size_t ADeviceHandle, const TLINQueueEvent_Win32_t ACallback);

//functional
//Scan the devices online
u32 tscan_scan_devices(uint32_t* ADeviceCount);
//get device information such as: manufactor, product id, serial no string
u32  tscan_get_device_info(
  const u32 ADeviceIndex,
  char** AFManufacturer,
  char** AFProduct,
  char** AFSerial
  );
//Connect device，ADeviceSerial !=NULL：connect the appointted device with serial no string；ADeviceSerial == NULL：connect default device
uint32_t tscan_connect(const char* ADeviceSerial, u64* AHandle);
//Disconnect the appointted device
u32 tscan_disconnect_by_handle(const size_t ADeviceHandle);
//Disconnect all devices
u32 tscan_disconnect_all_devices(void);
//initial libtscan driver module, which should be called before calling apis
void initialize_lib_tscan(bool AEnableFIFO, bool AEnableErrorFrame, bool AEnableTurbe);
//finalize libtscan driver module
void finalize_lib_tscan(void);

//CAN工具相关
//Synchronous transmit can message
u32 tscan_transmit_can_sync(const size_t ADeviceHandle, const TLibCAN* ACAN, const u32 ATimeoutMS);
//ASynchronous transmit can message
u32 tscan_transmit_can_async(const size_t ADeviceHandle, const TLibCAN* ACAN);

//Configuration of can baudrate
//ADeviceHandle:[In] Device Handle;
//AChnIdx:[In] Channel Index
//ARateKbps:[In] Baudrate(kbps), such as 500 means 500kbps
//A120OhmConnected:[In] Enable internal 120O terminal resistor
u32 tscan_config_can_by_baudrate(const size_t ADeviceHandle, const APP_CHANNEL AChnIdx, const double ARateKbps, const u32 A120OhmConnected);

//Read CAN Message from FIFO
//ADeviceHandle：[In]Device Handle；
//ACANBuffers:[In]Message Buffer；
//ACANBufferSize：[In,Out] In: message buffer size; Out: real message numer read from driver cache
//AChn:0-31: read the message from channel AChn; 0xFF: read the message from all channels of the device
//ARxTx:1: read transmitted and received messages; 0: only read the received messages, ignore the transmitted message
//return: ==0: success to read the data;
//          Other:error code
u32 tsfifo_receive_can_msgs(const size_t ADeviceHandle, const TLibCAN* ACANBuffers, s32* ACANBufferSize, u8 AChn, u8 ARXTX);

//CANFD工具相关
//Synchronous transmit canfd message
u32 tscan_transmit_canfd_sync(const size_t ADeviceHandle, const TLibCANFD* ACAN, const u32 ATimeoutMS);
//ASynchronous transmit canfd message
u32 tscan_transmit_canfd_async(const size_t ADeviceHandle, const TLibCANFD* ACAN);
//Configuration of canfd baudrate
//ADeviceHandle:[In] Device Handle;
//AChnIdx:[In] Channel Index
//AArbRateKbps:[In] Baudrate(kbps) of arb, such as 500 means 500kbps
//ADataRateKbps:[In] Baudrate(kbps) of data, such as 2000 means 2000kbps
//AControllerType[In]: Controller type: classic CAN, ISO-FDCAN, NoISO-FDCAN
//AControllerMode: Controller work mode
//A120OhmConnected:[In] Enable internal 120O terminal resistor
u32 tscan_config_canfd_by_baudrate(const size_t  ADeviceHandle, const APP_CHANNEL AChnIdx, const double AArbRateKbps, const double ADataRateKbps, const TLIBCANFDControllerType AControllerType,
	const TLIBCANFDControllerMode AControllerMode, const u32 A120OhmConnected);

//Read CANFD Message from FIFO
//ADeviceHandle：[In]Device Handle；
//ACANBuffers:[In]Message Buffer；
//ACANBufferSize：[In,Out] In: message buffer size; Out: real message numer read from driver cache
//AChn:0-31: read the message from channel AChn; 0xFF: read the message from all channels of the device
//ARxTx:1: read transmitted and received messages; 0: only read the received messages, ignore the transmitted message
//return: ==0: success to read the data;
//          Other:error code
u32 tsfifo_receive_canfd_msgs(const size_t ADeviceHandle, const TLibCANFD* ACANBuffers, s32* ACANBufferSize, u8 AChn, u8 ARXTX);

//LINC hannel
//ADeviceHandle[In]:Device Channel；
//AChnIdx[In]:Channel of device;
//AFunctionType[In]: funtion type of LIN Node, 0:MasterNode;1:SlaveNode;2:MonitorNode
u32 tslin_set_node_funtiontype(const size_t ADeviceHandle, const APP_CHANNEL AChnIdx, const u8 AFunctionType);
//Apply donwload new ldf file, which will clear the existing ldf information
u32 tslin_apply_download_new_ldf(const size_t ADeviceHandle, const APP_CHANNEL AChnIdx);
//Synchronous transmit lin message
u32 tslin_transmit_lin_sync(const size_t ADeviceHandle, const TLibLIN* ALIN, const u32 ATimeoutMS);
//ASynchronous transmit lin message
u32 tslin_transmit_lin_async(const size_t ADeviceHandle, const TLibLIN* ALIN);
//Synchronous transmit Fast lin message
u32 tslin_transmit_fastlin_async(const size_t ADeviceHandle, const TLibLIN* ALIN);
//Configuration of lin baudrate
u32 tslin_config_baudrate(const size_t ADeviceHandle, const APP_CHANNEL AChnIdx, const double ARateKbps, TLINProtocol AProtocol);

//Read LIN Message from FIFO
//ADeviceHandle：[In]Device Handle；
//ACANBuffers:[In]Message Buffer；
//ACANBufferSize：[In,Out] In: message buffer size; Out: real message numer read from driver cache
//AChn:0-31: read the message from channel AChn; 0xFF: read the message from all channels of the device
//ARxTx:1: read transmitted and received messages; 0: only read the received messages, ignore the transmitted message
//return: ==0: success to read the data;
//          Other:error code
u32 tsfifo_receive_lin_msgs(const size_t ADeviceHandle, const TLibLIN* ALINBuffers, s32* ALINBufferSize, u8 AChn, u8 ARXTX);

//Read LIN Message from FIFO
//ADeviceHandle：[In]Device Handle；
//ACANBuffers:[In]Message Buffer；
//ACANBufferSize：[In,Out] In: message buffer size; Out: real message numer read from driver cache
//AChn:0-31: read the message from channel AChn; 0xFF: read the message from all channels of the device
//ARxTx:1: read transmitted and received messages; 0: only read the received messages, ignore the transmitted message
//return: ==0: success to read the data;
//          Other:error code
u32 tsfifo_receive_fastlin_msgs(const size_t ADeviceHandle, const TLibLIN* ALINBuffers, s32* ALINBufferSize, u8 AChn, u8 ARXTX);

//get the error description
u32 tscan_get_error_description(const u32 ACode, char** ADesc);

//High precision playback API
s32 tsreplay_add_channel_map(const size_t ADeviceHandle, APP_CHANNEL ALogicChannel, APP_CHANNEL AHardwareChannel);
void tsreplay_clear_channel_map(const size_t ADeviceHandle);
s32 tsreplay_start_blf(const size_t ADeviceHandle, char* ABlfFilePath, int ATriggerByHardware, u64 AStartUs,u64 AEndUs);
s32 tsreplay_stop(const size_t ADeviceHandle);
s32 tsdiag_can_create(int* pDiagModuleIndex,
											u32 AChnIndex,
											byte ASupportFDCAN,
											byte AMaxDLC,
											u32 ARequestID,
											bool ARequestIDIsStd,
											u32 AResponseID,
											bool AResponseIDIsStd,
											u32 AFunctionID,
											bool AFunctionIDIsStd);

//diagnostic API
s32 tsdiag_can_delete(int ADiagModuleIndex);
s32 tsdiag_can_delete_all(void);
s32 tsdiag_can_attach_to_tscan_tool(int ADiagModuleIndex, size_t ACANToolHandle);
/*TP Raw Function*/
s32 tstp_can_send_functional(int ADiagModuleIndex,byte* AReqArray,int AReqArraySize, int ATimeOutMs);
s32 tstp_can_send_request(int ADiagModuleIndex, byte* AReqArray, int AReqArraySize, int ATimeOutMs);
s32 tstp_can_request_and_response(int ADiagModuleIndex,byte* AReqArray, int AReqArraySize,byte* AReturnArray,int* AReturnArraySize, int ATimeOutMs);

s32 tsdiag_can_session_control(int ADiagModuleIndex,byte ASubSession, byte ATimeoutMS);
s32 tsdiag_can_routine_control(int ADiagModuleIndex, byte AARoutineControlType,u16 ARoutintID, int  ATimeoutMS);
s32 tsdiag_can_communication_control(int ADiagModuleIndex, byte AControlType, int ATimeOutMs);
s32 tsdiag_can_security_access_request_seed(int ADiagModuleIndex,int ALevel,
                                                                  byte* ARecSeed, int* ARecSeedSize, int ATimeoutMS);
s32 tsdiag_can_security_access_send_key(int ADiagModuleIndex,int ALevel,byte* ASeed,int ASeedSize, int ATimeoutMS);
s32 tsdiag_can_request_download(int ADiagModuleIndex,u32 AMemAddr,u32 AMemSize, int ATimeoutMS);
s32 tsdiag_can_request_upload(int ADiagModuleIndex, u32 AMemAddr,u32 AMemSize, int ATimeoutMS);
s32 tsdiag_can_transfer_data(int ADiagModuleIndex,byte* ASourceDatas, int ASize,int AReqCase, int ATimeoutMS);
s32 tsdiag_can_request_transfer_exit(int ADiagModuleIndex,int ATimeoutMS);
s32 tsdiag_can_write_data_by_identifier(int ADiagModuleIndex,u16 ADataIdentifier,byte* AWriteData,
                                                              int AWriteDataSize, int ATimeOutMs);
s32 tsdiag_can_read_data_by_identifier(int ADiagModuleIndex, u16 ADataIdentifier, byte* AReturnArray,
 int* AReturnArraySize,int ATimeOutMs);

#ifdef __cplusplus
}
#endif


#pragma pack()

#endif
