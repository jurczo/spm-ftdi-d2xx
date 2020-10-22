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
    func testExample() {
        var count : DWORD = 0
        var status = FT_CreateDeviceInfoList(&count)
        guard status == FT_OK else {
            XCTFail("\(String(describing: FTDINativeError.init(rawValue: status)))")
            return
        }

        guard count > 0 else {
            XCTFail("No FTDI devices present for testing. Aborting!")
            return
        }

        var devs = [FT_DEVICE_LIST_INFO_NODE](repeating: .init(), count: Int(count))
        status = FT_GetDeviceInfoList(&devs, &count)
        guard status == FT_OK else {
            XCTFail("\(String(describing: FTDINativeError.init(rawValue: status)))")
            return
        }

        for dev in devs {
            print ("\(String.from(cTuple: dev.SerialNumber))")
        }
    }
}
