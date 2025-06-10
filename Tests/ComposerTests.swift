// © 2025  Cristian Felipe Patiño Rojas. Created on 9/6/25.

import XCTest
import BearPublisherCLI

class ComposerTests: XCTestCase {
    
    func test() throws {
        let dbURL = Bundle.module.url(forResource: "database", withExtension: "sqlite")!
        let sut = try make(dbPath: dbURL.path, outputURL: testSpecificURL())
        
        let allNoteList = try XCTUnwrap(sut.index.notes.filter({ $0.title == "All" }).first)
        
        allNoteList.notes.map(\.title) .* {
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
