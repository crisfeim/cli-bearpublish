// © 2025  Cristian Felipe Patiño Rojas. Created on 9/6/25.

import XCTest
import BearPublish

class IntegrationTests: XCTestCase {
    
    override func setUp() {
        try? FileManager.default.removeItem(at: testSpecificURL())
    }
    
    override func tearDown() {
        try? FileManager.default.removeItem(at: testSpecificURL())
    }
    
    private var dbPath: String {
        Bundle.module.url(forResource: "database", withExtension: "sqlite")!.path
    }
    
    func test_build_writesExpectedResources() async throws {
       try XCTExpectFailure {
            let _ = try BearPublisherComposer.make(dbPath: dbPath, outputURL: testSpecificURL())
            XCTFail("@todo: Implement")
        }
    }
    
}

// MARK: - Custom asserts
private extension IntegrationTests {
    
    func expectFileWithHashToExist(parentFolder: String, fileNamePrefix: String, file: StaticString = #filePath, line: UInt = #line) throws {
        
        let directoryURL = testSpecificURL().appendingPathComponent(parentFolder)
        
        let contents = try FileManager.default.contentsOfDirectory(
            at: directoryURL,
            includingPropertiesForKeys: nil
        )
        
        let cssFile = contents.first {
            $0.lastPathComponent.hasPrefix(fileNamePrefix)
        }
        
        XCTAssertNotNil(cssFile, "Expected to find a '\(fileNamePrefix)-<hash>' file in \(directoryURL.path)")
    }
    
    func expectFileAtPathToExist(_ path: String, file: StaticString = #filePath, line: UInt = #line) {
        XCTAssert(FileManager.default.fileExists(atPath: testSpecificURL().appendingPathComponent(path).path))
    }
}


// MARK: - Helpers
private extension IntegrationTests {
    func cachesDirectory() -> URL {
        return FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
    }
    
    func testSpecificURL() -> URL {
        cachesDirectory().appendingPathComponent("bearpublisher")
    }
}


// MARK: - My beloved asterisk
infix operator .*: AdditionPrecedence

@discardableResult
func .*<T>(lhs: T, rhs: (inout T) -> Void) -> T {
  var copy = lhs
  rhs(&copy)
  return copy
}
