//
//  DeviceCandidate.swift
//  RemoteTester
//
//  Created by Tomas Michalek on 19/10/2020.
//  Copyright © 2020 Gatema a.s. All rights reserved.
//

public struct DeviceCandidate {
    let flags : Int
    let type : FTDIDeviceType
    let devID : Int
    let locid : Int
    let serialNumber : String
    let desc : String
}

public extension DeviceCandidate {
    var dictionary : [String : Any] {
        return [
            "flags"  : self.flags,
            "type"   : self.type,
            "id"     : self.devID,
            "locid"  : self.locid,
            "serial" : self.serialNumber,
            "desc"   : self.desc,
        ]
    }

    init(from node: FT_DEVICE_LIST_INFO_NODE) {
        self.init(
            flags: Int(node.Flags),
            type: FTDIDeviceType(rawValue: node.Type) ?? .unknown,
            devID: Int(node.ID),
            locid: Int(node.LocId),
            serialNumber: String.from(cTuple: node.SerialNumber),
            desc: String.from(cTuple: node.Description)
        )
    }
}

extension String {
    static func from<T>(cTuple tuple: T) -> String {
        let mirror = Mirror(reflecting: tuple)
        let chars = mirror.children.map { CChar($0.value as! Int8) }
        return String(cString: chars)
    }
}

extension FT_DEVICE_LIST_INFO_NODE {
    var dictionary : [String : Any] {
        return DeviceCandidate(from: self).dictionary
    }
}
