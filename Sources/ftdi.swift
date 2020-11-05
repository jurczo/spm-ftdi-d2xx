// Copyright © 2020 Tomáš Michalek
// See the file "LICENSE" for the full license governing this code.

import Foundation

//MARK: - Discovery

public func availableCandidates() throws -> [DeviceCandidate] {
    var count : DWORD = 0
    var status = FT_CreateDeviceInfoList(&count)
    guard status == FT_OK else {
        throw FTDIError.raw(ftdiCode: status)
    }

    guard count > 0 else {
        throw FTDIError.noDevicesPresent
    }

    var devs = [FT_DEVICE_LIST_INFO_NODE](repeating: .init(), count: Int(count))
    status = FT_GetDeviceInfoList(&devs, &count)
    guard status == FT_OK else {
        throw FTDIError.raw(ftdiCode: status)
    }

    return devs.map { DeviceCandidate(from: $0) }
}

public func availableDevices() throws -> [[String : Any]] {
    return try availableCandidates().map { $0.dictionary }
}

//MARK: - Lifecycle

public func open(using: FTDIOpenBy, value: Any) throws -> FT_HANDLE {
    var mutableValue = value
    var handle : FT_HANDLE?

    let status = FT_OpenEx(&mutableValue, using.rawValue, &handle)
    guard status == FT_OK else { throw FTDIError.raw(ftdiCode: status) }

    guard let unwrapped = handle else { throw FTDIError.unwrapError }
    return unwrapped
}

public func close(_ handle: FT_HANDLE) throws {
    var status = FT_ResetDevice(handle)
    guard status == FT_OK else { throw FTDIError.raw(ftdiCode: status) }

    status = FT_Close(handle)
    guard status == FT_OK else { throw FTDIError.raw(ftdiCode: status) }
}

public func describe(_ handle: FT_HANDLE) throws -> DeviceRuntimeInfo {
    var dev = FT_DEVICE(FT_DEVICE_UNKNOWN)
    var id : DWORD = 0
    var serial = [CChar](repeating: 0, count: 16) ///see device_get_info
    var desc = [CChar](repeating: 0, count: 64)

    let status = FT_GetDeviceInfo(handle, &dev, &id, &serial, &desc, nil)
    guard status == FT_OK else { throw FTDIError.raw(ftdiCode: status) }

    return DeviceRuntimeInfo (
        serialNumber: String(cString: serial),
        description: String(cString: desc),
        type: FTDIDeviceType(rawValue: dev) ?? .unknown,
        id: id
    )
}

//MARK: - Configuration

public func set(_ handle: FT_HANDLE, baudRate: FTDIBaudrate) throws {
    let status = FT_SetBaudRate(handle, baudRate.rawValue)
    guard status == FT_OK else {  throw FTDIError.raw(ftdiCode: status) }
}

public func set(_ handle: FT_HANDLE, flow: FTDIFlow) throws {
    let status = FT_SetFlowControl(handle, USHORT(flow.rawValue), 0, 0)
    guard status == FT_OK else { throw FTDIError.raw(ftdiCode: status) }
}

func set(_ handle: FT_HANDLE, bits: FTDIBits, stops: FTDIStopBits, parity: FTDIParity) throws {
    let status = FT_SetDataCharacteristics(handle, bits.rawValue, stops.rawValue, parity.rawValue)
    guard status == FT_OK else { throw FTDIError.raw(ftdiCode: status) }
}

func set(_ handle: FT_HANDLE, dtr: Bool) throws {
    let status = dtr ? FT_SetDtr(handle) : FT_ClrDtr(handle)
    guard status == FT_OK else {
        throw FTDIError.raw(ftdiCode: status)
    }
}

func set(_ handle: FT_HANDLE, rts: Bool) throws {
    let status = rts ? FT_SetRts(handle) : FT_ClrRts(handle)
    guard status == FT_OK else {
        throw FTDIError.raw(ftdiCode: status)
    }
}

public func configure(_ handle: FT_HANDLE, using configuration: Configuration) throws {
    try set(handle, baudRate: configuration.baudrate)
    try set(handle, bits: configuration.bits,
                    stops: configuration.stopBits,
                    parity: configuration.parity)
    try set(handle, flow: configuration.flow)
    try set(handle, dtr: configuration.dtr)
    try set(handle, rts: configuration.rts)
}

//MARK: - Send to Device
public func write(_ handle: FT_HANDLE, bytes: Any, length: Int) throws {
    var written : DWORD = 0
    var mutableBytes = bytes

    //TODO: Is it needed (it is shown in example from FTDI)
    try? set(handle, rts: true) // Signal intent to send data to remote host

    let status = FT_Write(handle, &mutableBytes, DWORD(length), &written)
    guard status == FT_OK else { throw FTDIError.raw(ftdiCode: status) }

    guard length == written else { throw FTDIError.invalidWrite }
}

public func write(_ handle: FT_HANDLE, raw data: [UInt8]) throws {
    try write(handle, bytes: data, length: data.count)
}

public func write(_ handle: FT_HANDLE, string: String) throws {
    let stringArray = string.utf8CString.map { UInt8($0) }
    try write(handle, raw: stringArray)
}

//MARK: - Receive from Device
public func read(_ handle: FT_HANDLE, length: DWORD) throws -> [CChar] {
    var buffer : [CChar] = .init(repeating: 0, count: 256) //FIXME: maybe use the length instead of fixed length
    var received : DWORD = 0

    let status = FT_Read(handle, &buffer, length, &received)
    guard status == FT_OK else {
        throw FTDIError.raw(ftdiCode: status)
    }

    return buffer
}

public typealias ModemStatusHandler = ((_ status: DWORD) -> Void)
public typealias ReadDataHandler = ((_ data: Data) -> Void)

/// Check is the event is a modem status one.
///
/// - Parameter event: Status word for the event
/// - Returns: Boolean value
private func isModemEvent(_ event : DWORD) -> Bool {
    return (event & DWORD(FT_EVENT_MODEM_STATUS)) == DWORD(FT_EVENT_MODEM_STATUS)
}

public func bootstrap(event eh: inout EVENT_HANDLE) {
    pthread_mutex_init(&eh.eMutex, nil)
    pthread_cond_init(&eh.eCondVar, nil)
}

public func readSync(_ handle : FT_HANDLE, eventHandle eh: inout EVENT_HANDLE, onModemStatusChanged: ModemStatusHandler? = nil, onNewData: ReadDataHandler? = nil) throws {

    let mask : DWORD = .init(FT_EVENT_RXCHAR | FT_EVENT_MODEM_STATUS) //  | FT_EVENT_LINE_STATUS
    //FT_DEFAULT_RX_TIMEOUT
    var status = FT_SetEventNotification(handle, mask, &eh)
    guard status == FT_OK else { throw FTDIError.raw(ftdiCode: status) }

    pthread_mutex_lock(&eh.eMutex)
    pthread_cond_wait(&eh.eCondVar, &eh.eMutex)
    pthread_mutex_unlock(&eh.eMutex)

    var event : DWORD = 0
    var rx : DWORD = 0
    var tx : DWORD = 0

    status = FT_GetStatus(handle, &rx, &tx, &event)
    guard status == FT_OK else { throw FTDIError.raw(ftdiCode: status) }

    if isModemEvent(event) {
        var state : DWORD = 0
        status = FT_GetModemStatus(handle, &state)
        guard status == FT_OK else { throw FTDIError.raw(ftdiCode: status) }
        onModemStatusChanged?(state)
    }

    if rx > 0 {
        let raw = try read(handle, length: rx)
        let data = Data(bytes: raw, count: raw.count)
        onNewData?(data)
    }
}

public func decode(modemStatus state: DWORD) -> ModemStatus {
    let cts = !((state & MS_CTS_ON) == MS_CTS_ON)
    let dsr = !((state & MS_DSR_ON) == MS_DSR_ON)
    let ring = !((state & MS_RING_ON) == MS_RING_ON)
    let rlsd = !((state & MS_RLSD_ON) == MS_RLSD_ON)

    return ModemStatus(cts: cts, dsr: dsr, ring: ring, rlsd: rlsd)
}
