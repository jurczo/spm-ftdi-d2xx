// Copyright © 2020 Tomáš Michalek
// See the file "LICENSE" for the full license governing this code.

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
