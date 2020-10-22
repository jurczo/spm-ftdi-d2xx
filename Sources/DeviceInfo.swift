//
//  DeviceInfo.swift
//  FTDI
//
//  Created by Tomas Michalek on 22/10/2020.
//

public struct DeviceRuntimeInfo {
    let serialNumber : String
    let `description` : String
    let type : FTDIDeviceType
    let id : DWORD
}
