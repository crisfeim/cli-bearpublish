// © 2025  Cristian Felipe Patiño Rojas. Created on 9/6/25.

import XCTest
import BearPublisherCLI

class ComposerTests: XCTestCase {
    
    private var dbPath: String {
        Bundle.module.url(forResource: "database", withExtension: "sqlite")!.path
    }

    func test() throws {
        let sut = try makeSite(dbPath: dbPath, outputURL: testSpecificURL())
        
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
    
    func test_build_writesResources() async throws {
        let sut = try makeSite(dbPath: dbPath, outputURL: testSpecificURL())
        try await sut.build()
        
        XCTAssert(FileManager.default.fileExists(atPath: testSpecificURL().appendingPathComponent("standalone/note").path))
        XCTAssert(FileManager.default.fileExists(atPath: testSpecificURL().appendingPathComponent("standalone/list").path))
        XCTAssert(FileManager.default.fileExists(atPath: testSpecificURL().appendingPathComponent("standalone/tag").path))
        XCTAssert(FileManager.default.fileExists(atPath: testSpecificURL().appendingPathComponent("assets/css").path))
        XCTAssert(FileManager.default.fileExists(atPath: testSpecificURL().appendingPathComponent("assets/js").path))
    }
}


infix operator .*: AdditionPrecedence

@discardableResult
func .*<T>(lhs: T, rhs: (inout T) -> Void) -> T {
  var copy = lhs
  rhs(&copy)
  return copy
}

private extension ComposerTests {
    func cachesDirectory() -> URL {
        return FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
    }
    
    func testSpecificURL() -> URL {
        cachesDirectory().appendingPathComponent("bearpublisher")
    }
}
