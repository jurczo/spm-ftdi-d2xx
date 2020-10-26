//
//  FTDI.h
//
//  Wrapper around the RAW types from D2xx driver in order to make them work
//  properly in the Swift.
//
//  Created by Tomas Michalek on 22/09/2020.
//  Copyright © 2020 Gatema a.s. All rights reserved.
//

#pragma once
@import Foundation;
#import <FTDI/WinTypes.h>
#import <FTDI/ftd2xx.h>

typedef NS_OPTIONS(DWORD, FTDIOpenBy) {
    FTDIOpenBySerialNumber = 1 << 0, // FT_OPEN_BY_SERIAL_NUMBER
    FTDIOpenByDescription  = 1 << 1, // FT_OPEN_BY_DESCRIPTION
    FTDIOpenByLocation     = 1 << 2, // FT_OPEN_BY_LOCATION
};

typedef NS_OPTIONS(DWORD, FTDIEvent) {
    FTDIEventRxChar         = 1 << 0, // FT_EVENT_RXCHAR
    FTDIEventModemStatus    = 1 << 1, // FT_EVENT_MODEM_STATUS
    FTDIEventLineStatus     = 1 << 2, // FT_EVENT_LINE_STATUS
};

typedef NS_CLOSED_ENUM(DWORD, FTDIFlow) {
    FTDIFlowNone    = FT_FLOW_NONE,
    FTDIFlowRtsCts  = FT_FLOW_RTS_CTS,
    FTDIFlowDtrDsr  = FT_FLOW_DTR_DSR,
    FTDIFlowXonXoff = FT_FLOW_XON_XOFF,
};

typedef NS_ENUM(ULONG, FTDIBaudrate) {
    FTDIBaudrateBaud300     = FT_BAUD_300,
    FTDIBaudrateBaud600     = FT_BAUD_600,
    FTDIBaudrateBaud1200    = FT_BAUD_1200,
    FTDIBaudrateBaud2400    = FT_BAUD_2400,
    FTDIBaudrateBaud4800    = FT_BAUD_4800,
    FTDIBaudrateBaud9600    = FT_BAUD_9600,
    FTDIBaudrateBaud14400   = FT_BAUD_14400,
    FTDIBaudrateBaud19200   = FT_BAUD_19200,
    FTDIBaudrateBaud38400   = FT_BAUD_38400,
    FTDIBaudrateBaud57600   = FT_BAUD_57600,
    FTDIBaudrateBaud115200  = FT_BAUD_115200,
    FTDIBaudrateBaud230400  = FT_BAUD_230400,
    FTDIBaudrateBaud460800  = FT_BAUD_460800,
    FTDIBaudrateBaud921600  = FT_BAUD_921600,
};

typedef NS_CLOSED_ENUM(UCHAR, FTDIStopBits) {
    FTDIStopBitsOne = FT_STOP_BITS_1,
    FTDIStopBitsTwo = FT_STOP_BITS_2,
};

typedef NS_CLOSED_ENUM(UCHAR, FTDIBits) {
    FTDIBitsBits8 = FT_BITS_8,
    FTDIBitsBits7 = FT_BITS_7,
};

typedef NS_CLOSED_ENUM(UCHAR, FTDIParity) {
    FTDIParityNone  = FT_PARITY_NONE,
    FTDIParityOdd   = FT_PARITY_ODD,
    FTDIParityEven  = FT_PARITY_EVEN,
    FTDIParityMark  = FT_PARITY_MARK,
    FTDIParitySpace = FT_PARITY_SPACE,
};

typedef NS_CLOSED_ENUM(ULONG, FTDIDeviceType) {
    FTDIDeviceTypeUnknown = FT_DEVICE_UNKNOWN,
    FTDIDeviceTypeBM      = FT_DEVICE_BM,
    FTDIDeviceTypeAM      = FT_DEVICE_AM,
    FTDIDeviceTypeAX100   = FT_DEVICE_100AX,
    FTDIDeviceTypeC2232   = FT_DEVICE_2232C,
    FTDIDeviceTypeH2232   = FT_DEVICE_2232H,
    FTDIDeviceTypeR232    = FT_DEVICE_232R,
    FTDIDeviceTypeH232    = FT_DEVICE_232H,
    FTDIDeviceTypeH4232   = FT_DEVICE_4232H,
    FTDIDeviceTypeXSeries = FT_DEVICE_X_SERIES,
    FTDIDeviceTypeH4222_0 = FT_DEVICE_4222H_0,
    FTDIDeviceTypeH4222_13= FT_DEVICE_4222H_1_2,
    FTDIDeviceTypeH4222_3 = FT_DEVICE_4222H_3,
    FTDIDeviceTypeH4222_Prog = FT_DEVICE_4222_PROG,
    FTDIDeviceTypeX900 = FT_DEVICE_900,
    FTDIDeviceTypeX930 = FT_DEVICE_930,
    FTDIDeviceTypeUMFTPD3A = FT_DEVICE_UMFTPD3A,
};

typedef NS_CLOSED_ENUM(uint32_t, FTDINativeError) {
    FTDINativeErrorOk                       = FT_OK,
    FTDINativeErrorInvalidHandle            = FT_INVALID_HANDLE,
    FTDINativeErrorDeviceNotFound           = FT_DEVICE_NOT_FOUND,
    FTDINativeErrorDeviceNotOpened          = FT_DEVICE_NOT_OPENED,
    FTDINativeErrorIoError                  = FT_IO_ERROR,
    FTDINativeErrorInsufficientResources    = FT_INSUFFICIENT_RESOURCES,
    FTDINativeErrorInvalidParameter         = FT_INVALID_PARAMETER,
    FTDINativeErrorInvalidBaudRate          = FT_INVALID_BAUD_RATE,    //7
    FTDINativeErrorDeviceNotOpenedForErase  = FT_DEVICE_NOT_OPENED_FOR_ERASE,
    FTDINativeErrorDeviceNotOpenedForWrite  = FT_DEVICE_NOT_OPENED_FOR_WRITE,
    FTDINativeErrorFailedToWriteDevice      = FT_FAILED_TO_WRITE_DEVICE,
    FTDINativeErrorEEPROMReadFailed         = FT_EEPROM_READ_FAILED,
    FTDINativeErrorEEPROMWriteFailed        = FT_EEPROM_WRITE_FAILED,
    FTDINativeErrorEEPROMEraseFailed        = FT_EEPROM_ERASE_FAILED,
    FTDINativeErrorEEPROMNotPresent         = FT_EEPROM_NOT_PRESENT,
    FTDINativeErrorEEPROMNotProgrammed      = FT_EEPROM_NOT_PROGRAMMED,
    FTDINativeErrorInvalidArguments         = FT_INVALID_ARGS,
    FTDINativeErrorNotSupported             = FT_NOT_SUPPORTED,
    FTDINativeErrorOther                    = FT_OTHER_ERROR,
    FTDINativeErrorDeviceListNotRead        = FT_DEVICE_LIST_NOT_READY,
};

typedef NS_CLOSED_ENUM(uint32_t, FTDILineStatus) {
    FTDILineStatusOE = 0x02,
    FTDILineStatusPE = 0x04,
    FTDILineStatusFE = 0x08,
    FTDILineStatusBI = 0x10,
};
