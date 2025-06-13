// © 2025  Cristian Felipe Patiño Rojas. Created on 9/6/25.

import XCTest
import BearPublish
@testable import BearPublishCLI

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
    
    func test_cli_buildsExpectedFilesAtOutputURL() async throws {
        let cli = try BearPublisherCLI.parse([
            "--input", dbPath,
            "--output", testSpecificURL().path,
            "--title", "Test Site"
        ])
        
        try await cli.run()
        
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
    
    func test_bearPublisherComposerExecute_buildsExpectedFilesAtOutputURL() async throws {
        let sut = try BearPublisherComposer.make(
            dbPath: dbPath,
            outputURL: testSpecificURL(),
            siteTitle: "any title"
        )
        
        try await sut.execute()
        
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
