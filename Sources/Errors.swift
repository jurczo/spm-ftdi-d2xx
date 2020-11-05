// Copyright © 2020 Tomáš Michalek
// See the file "LICENSE" for the full license governing this code.

public enum FTDIError : Error {
    case raw(ftdiCode: UInt32)
    case invalidWrite
    case invalidWriteData
    case noDevicesPresent
    case unwrapError
}

extension FTDIError : CustomStringConvertible {
    public var description: String {
        switch self {
        case .raw(let code):
            return FTDINativeError(rawValue: code)?.description ?? "Invalid Error code."
        case .invalidWrite:
            return "Invalid write operation."
        case .invalidWriteData:
            return "Invalid data provided to write operation."
        case .noDevicesPresent:
            return "Detected no usable devices present in the system."
        case .unwrapError:
            return "Unexpected null value."
        }
    }
}

extension FTDINativeError : CustomStringConvertible {
    public var description: String {
        switch self {
        case .deviceNotFound: return "Device not found."
        case .deviceNotOpened: return "Device not opened."
        case .deviceNotOpenedForErase : return "Device cannot be opened in ERASE mode."
        case .deviceNotOpenedForWrite : return "Device cannot be opened in WRITE mode."
        case .eepromEraseFailed : return "Failed to erase EEPROM."
        case .eepromReadFailed : return "Failed to read EEPROM."
        case .eepromWriteFailed : return "Failded to write to EEPROM."
        case .eepromNotPresent : return "EEPROM missing or malformated."
        case .eepromNotProgrammed : return "EEPROM is not programmed."
        case .failedToWriteDevice : return "Failed to write DEVICE."
        case .insufficientResources : return "Isufficient resources to perform operation."
        case .invalidArguments : return "One or more arguments are invalid."
        case .ioError : return "Encountered I/O error."
        case .invalidParameter : return "Parameter is invalid or missing."
        case .invalidHandle : return "Invalid device handle."
        case .invalidBaudRate : return "Invalid Baud rate for the device."
        case .notSupported : return "Operation not supported."
        case .other : return "Unspecified other error occured."
        case .ok : return "Operation successful."
        case .deviceListNotRead: return "Device is not ready to provide device list."
        }
    }
}
