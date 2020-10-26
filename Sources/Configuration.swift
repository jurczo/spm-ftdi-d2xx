//
//  Configuration.swift
//  RemoteTester
//
//  Configuration structure for initialization of the USB FTDI device.
//
//  Created by Tomas Michalek on 13/10/2020.
//  Copyright © 2020 Gatema a.s. All rights reserved.
//

public struct Configuration {
    public let flow     : FTDIFlow     = .none
    public let baudrate : FTDIBaudrate = .baud9600
    public let bits     : FTDIBits     = .bits8
    public let parity   : FTDIParity   = .none
    public let stopBits : FTDIStopBits = .one

    public let rts : Bool = false
    public let dtr : Bool = true

    public init() {}
}
