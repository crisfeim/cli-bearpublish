// © 2025  Cristian Felipe Patiño Rojas. Created on 15/6/25.


import XCTest
import BearPublish

extension XCTest {
#warning("@todo: Assert file contets")
    func expectFileAtPathToExist(_ path: String, at directoryURL: URL, file: StaticString = #filePath, line: UInt = #line) {
        XCTAssert(FileManager.default.fileExists(atPath: directoryURL.appendingPathComponent(path).path))
    }
}
