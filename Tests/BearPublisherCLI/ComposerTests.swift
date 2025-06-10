// © 2025  Cristian Felipe Patiño Rojas. Created on 9/6/25.

import XCTest
import BearPublisherCLI

class ComposerTests: XCTestCase {
    
    private var dbPath: String {
        Bundle.module.url(forResource: "database", withExtension: "sqlite")!.path
    }
    
    func test() throws {
        let sut = try BearSite.make(dbPath: dbPath, outputURL: testSpecificURL())
        
        let allNoteList = try XCTUnwrap(sut.index.notes.filter({ $0.title == "All" }).first)
        
        allNoteList.notes.map(\.title) .* {
            XCTAssertEqual($0.count, 8)
            XCTAssertFalse($0.contains("Trashed note"))
            XCTAssertFalse($0.contains("Archived note"))
            XCTAssertTrue($0.contains("Encrypted note"))
            XCTAssertTrue($0.contains("Note with undone tasks"))
            XCTAssertTrue($0.contains("Note with file"))
            XCTAssertTrue($0.contains("Regular note"))
            XCTAssertTrue($0.contains("Note with tag"))
            XCTAssertTrue($0.contains("Pinned note"))
            XCTAssertTrue($0.contains("Note with source code"))
            XCTAssertTrue($0.contains("Note with done tasks"))
        }
        
        sut.listsByCategory.lists.map(\.title) .* {
            XCTAssertEqual($0.count, 4)
            XCTAssertTrue($0.contains("Archived"))
            XCTAssertTrue($0.contains("Trashed"))
            XCTAssertTrue($0.contains("All"))
            XCTAssertTrue($0.contains("Tasks"))
        }
        
        sut.listsByHashtag.lists.map(\.slug) .* {
            XCTAssertEqual($0.count, 5)
            XCTAssertTrue($0.contains("dev"))
            XCTAssertTrue($0.contains("code"))
            XCTAssertTrue($0.contains("sometag"))
            XCTAssertTrue($0.contains("sometag&nested"))
            XCTAssertTrue($0.contains("sometag&nested&nested"))
        }
    }
    
    func test_build_writesExpectedResources() async throws {
        let sut = try BearSite.make(dbPath: dbPath, outputURL: testSpecificURL())
        try await sut.build()
        
        expectFileAtPathToExist("index.html")
        
        expectFileAtPathToExist("standalone/note/archived-note.html")
        expectFileAtPathToExist("standalone/note/encrypted-note.html")
        expectFileAtPathToExist("standalone/note/note-with-done-tasks.html")
        expectFileAtPathToExist("standalone/note/note-with-file.html")
        expectFileAtPathToExist("standalone/note/note-with-source-code.html")
        expectFileAtPathToExist("standalone/note/note-with-tag.html")
        expectFileAtPathToExist("standalone/note/note-with-undone-tasks.html")
        expectFileAtPathToExist("standalone/note/pinned-note.html")
        expectFileAtPathToExist("standalone/note/regular-note.html")
        expectFileAtPathToExist("standalone/note/trashed-note.html")
        
        expectFileAtPathToExist("standalone/list/all.html")
        expectFileAtPathToExist("standalone/list/archived.html")
        expectFileAtPathToExist("standalone/list/tasks.html")
        expectFileAtPathToExist("standalone/list/trashed.html")
        
        expectFileAtPathToExist("standalone/tag/code.html")
        expectFileAtPathToExist("standalone/tag/dev.html")
        expectFileAtPathToExist("standalone/tag/sometag.html")
        expectFileAtPathToExist("standalone/tag/sometag&nested.html")
        expectFileAtPathToExist("standalone/tag/sometag&nested&nested.html")
        
        expectFileAtPathToExist("assets/css")
        
        
        try expectFileWithHashToExist(parentFolder: "assets/css", fileNamePrefix: "theme-variables")
        try expectFileWithHashToExist(parentFolder: "assets/css", fileNamePrefix: "styles")
        
        try expectFileWithHashToExist(parentFolder: "assets/js", fileNamePrefix: "htmx")
        try expectFileWithHashToExist(parentFolder: "assets/js", fileNamePrefix: "hyperscript")
        try expectFileWithHashToExist(parentFolder: "assets/js", fileNamePrefix: "main")
        
        expectFileAtPathToExist("assets/js")
    }
    
}

// MARK: - Custom asserts
private extension ComposerTests {
    
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
private extension ComposerTests {
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
