// © 2025  Cristian Felipe Patiño Rojas. Created on 15/6/25.


import XCTest
import BearPublish

protocol OutputFilesystemTestCase: XCTestCase {}
extension OutputFilesystemTestCase {
    
    func expectFileAtPathToExist(_ path: String, at directoryURL: URL, file: StaticString = #filePath, line: UInt = #line) {
        XCTAssert(FileManager.default.fileExists(atPath: directoryURL.appendingPathComponent(path).path))
    }
    
    
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
