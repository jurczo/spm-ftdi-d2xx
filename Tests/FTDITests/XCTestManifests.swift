import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(FTDI_D2xxTests.allTests),
    ]
}
#endif
