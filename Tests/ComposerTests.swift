// © 2025  Cristian Felipe Patiño Rojas. Created on 9/6/25.

import XCTest
import BearPublisherCLI

class ComposerTests: XCTestCase {
    
    override func setUp() {
        try? FileManager.default.removeItem(at: testSpecificURL())
    }
    
    override func tearDown() {
        try? FileManager.default.removeItem(at: testSpecificURL())
    }
    
    func test() throws {
        let dbURL = Bundle.module.url(forResource: "database", withExtension: "sqlite")!
        let sut = try make(dbPath: dbURL.path, outputURL: testSpecificURL())

        expect(sut.index.contents, toNotContainNotesWithTitles: ["Trashed note", "Archived note"])
        expect(sut.index.contents, toContainNotesWithTitles: ["Encrypted note",
                                                 "Note with undone tasks",
                                                 "Note with file",
                                                 "Regular note",
                                                 "Note with tag",
                                                 "Pinned note",
                                                 "Note with source code",
                                                 "Note with done tasks"])
    }
    
    func test_build_writesResources() async throws {
        let dbURL = Bundle.module.url(forResource: "database", withExtension: "sqlite")!
        let sut = try make(dbPath: dbURL.path, outputURL: testSpecificURL())
        
        try await sut.build()
        
        XCTAssert(FileManager.default.fileExists(atPath: testSpecificURL().appendingPathComponent("standalone/note").path))
        XCTAssert(FileManager.default.fileExists(atPath: testSpecificURL().appendingPathComponent("standalone/list").path))
        XCTAssert(FileManager.default.fileExists(atPath: testSpecificURL().appendingPathComponent("standalone/tag").path))
        XCTAssert(FileManager.default.fileExists(atPath: testSpecificURL().appendingPathComponent("assets/css").path))
        XCTAssert(FileManager.default.fileExists(atPath: testSpecificURL().appendingPathComponent("assets/js").path))
    }
}

private extension ComposerTests {
    func expect(_ string: String, toNotContainNotesWithTitles titles: [String], file: StaticString = #filePath, line: UInt = #line) {
        titles.forEach {
            XCTAssertFalse(string.contains($0), "Expected to not contain \($0)", file: file, line: line)
        }
    }
    
    func expect(_ string: String, toContainNotesWithTitles titles: [String], file: StaticString = #filePath, line: UInt = #line) {
        titles.forEach {
            XCTAssert(string.contains($0), "Expected to contain \($0)", file: file, line: line)
        }
    }
    
    func cachesDirectory() -> URL {
        return FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
    }
    
    func testSpecificURL() -> URL {
        cachesDirectory().appendingPathComponent("bearpublisher")
    }
}
