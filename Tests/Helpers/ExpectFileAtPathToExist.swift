// © 2025  Cristian Felipe Patiño Rojas. Created on 15/6/25.


import XCTest
import BearPublish

extension XCTest {
#warning("@todo: Assert file contets")
    func expectFileAtPathToExist(_ path: String, at directoryURL: URL, file: StaticString = #filePath, line: UInt = #line) {
        XCTAssert(FileManager.default.fileExists(atPath: directoryURL.appendingPathComponent(path).path))
    }
}


extension XCTestCase {
    
    func cachesDirectory() -> URL {
        return FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
    }
    
    func testSpecificURL() -> URL {
        cachesDirectory().appendingPathComponent("\(type(of: self))")
    }
    
    func outputFolder() -> URL {
        testSpecificURL().appendingPathComponent("output")
    }
}
