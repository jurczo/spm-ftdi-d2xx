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
    let flow     : FTDIFlow     = .none
    let baudrate : FTDIBaudrate = .baud9600
    let bits     : FTDIBits     = .bits8
    let parity   : FTDIParity   = .none
    let stopBits : FTDIStopBits = .one

    let rts : Bool = false
    let dtr : Bool = true
}
