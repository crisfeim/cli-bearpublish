// © 2025  Cristian Felipe Patiño Rojas. Created on 9/6/25.

import XCTest
import BearPublisherCLI

class ComposerTests: XCTestCase {
    
    func test() throws {
       try XCTExpectFailure {
            let dbURL = Bundle.module.url(forResource: "database", withExtension: "sqlite")!
            let sut = try make(dbPath: dbURL.path, outputURL: testSpecificURL())
            
            try sut.build()
            
            XCTAssert(FileManager.default.fileExists(atPath: testSpecificURL().appendingPathComponent("standalone/note").path))
            XCTAssert(FileManager.default.fileExists(atPath: testSpecificURL().appendingPathComponent("standalone/list").path))
            XCTAssert(FileManager.default.fileExists(atPath: testSpecificURL().appendingPathComponent("standalone/tag").path))
            NSWorkspace.shared.open(testSpecificURL())
        }
    }
    
    private func cachesDirectory() -> URL {
        return FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
    }
    
    private func testSpecificURL() -> URL {
        cachesDirectory().appendingPathComponent("bearpublisher")
    }
}
