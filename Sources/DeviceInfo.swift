//
//  DeviceInfo.swift
//  FTDI
//
//  Created by Tomas Michalek on 22/10/2020.
//

public struct DeviceRuntimeInfo {
    public let serialNumber : String
    public let `description` : String
    public let type : FTDIDeviceType
    public let id : DWORD
}
