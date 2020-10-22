import XCTest
import Foundation
@testable import FTDI

extension String {
    static func from<T>(cTuple tuple: T) -> String {
        let mirror = Mirror(reflecting: tuple)
        let chars = mirror.children.map { CChar($0.value as! Int8) }
        return String(cString: chars)
    }
}

final class FTDITests: XCTestCase {
    func testListDevices() {
        do {
            let list = try availableDevices()
            print(list)
        } catch {
            print(error)
            XCTFail()
        }
    }

    func testListDeviceCandidates() {
        do {
            let list = try availableCandidates()
            print(list)
        } catch {
            print(error)
            XCTFail()
        }
    }

    func testOpenDeviceSerial() {
        do {
            guard let serial = try availableCandidates().first?.serialNumber else {
                XCTFail()
                return
            }
            let handle = try open(using: .serialNumber, value: serial)
            try close(handle)
        } catch {
            print(error)
            XCTFail()
        }
    }

    func testOpenDeviceDescription() {
        //FIXME: Posibility to open device by description
        return
//        do {
//            guard let value = try availableCandidates().first?.desc else {
//                XCTFail()
//                return
//            }
//            let handle = try open(using: .description, value: value)
//            try close(handle)
//        } catch {
//            print(error)
//            XCTFail()
//        }
    }

    func testOpenDeviceId() {
        //FIXME: Posibility to open device by (Loc)ID
        return
//        do {
//            guard let value = try availableCandidates().first?.locid else {
//                XCTFail()
//                return
//            }
//            let handle = try open(using: .location, value: value)
//            try close(handle)
//        } catch {
//            print(error)
//            XCTFail()
//        }
    }

    func testDeviceRuntimeInfo() {
        do {
            guard let serial = try availableCandidates().first?.serialNumber else {
                XCTFail()
                return
            }
            let handle = try open(using: .serialNumber, value: serial)
            let info = try describe(handle)
            print(info)
            try close(handle)
        } catch {
            print(error)
            XCTFail()
        }
    }

    func testManualButtonPressed() {
        do {
            guard let serial = try availableCandidates().first?.serialNumber else {
                XCTFail()
                return
            }
            let handle = try open(using: .serialNumber, value: serial)

            for _ in 0 ... 3 {
                try readAsync(handle) {
                    print(decode(modemStatus: $0))
                    XCTAssert(true)
                } onNewData: {
                    print($0)
                    XCTAssert(true)
                }
            }

            try close(handle)
        } catch {
            print(error)
            XCTFail()
        }
    }
}
