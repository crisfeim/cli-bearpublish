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
    
    private var filesFolder: URL {
        testSpecificURL().appendingPathComponent("files")
    }
    
    private var imagesFolder: URL {
        testSpecificURL().appendingPathComponent("images")
    }
    
    
    private var dbPath: String {
        Bundle.module.url(forResource: "database", withExtension: "sqlite")!.path
    }
    
    func test_cli_buildsExpectedFilesAtOutputURL() async throws {
        try FileManager.default.createDirectory(at: filesFolder, withIntermediateDirectories: true)
        try FileManager.default.createDirectory(at: imagesFolder, withIntermediateDirectories: true)
        let cli = try BearPublisherCLI.parse([
            "--db-path", dbPath,
            "--output", outputFolder().path,
            "--images-folder-path", imagesFolder.path,
            "--files-folder-path", filesFolder.path,
            "--title", "Test Site"
        ])
        
        try await cli.run()
        expectSiteToExist(at: outputFolder())
    }
    
    func test_bearPublisherComposerExecute_buildsExpectedFilesAtOutputURL() async throws {
        try FileManager.default.createDirectory(at: filesFolder, withIntermediateDirectories: true)
        try FileManager.default.createDirectory(at: imagesFolder, withIntermediateDirectories: true)
        let sut = try BearPublisherComposer.make(
            dbPath: dbPath,
            outputURL: outputFolder(),
            filesFolderURL: filesFolder,
            imagesFolderURL: imagesFolder,
            siteTitle: "any title"
        )
        
        try await sut.execute()
        expectSiteToExist(at: outputFolder())
    }
}

// MARK: - Custom asserts
private extension IntegrationTests {
    
    func expectSiteToExist(at outputURL: URL, file: StaticString = #filePath, line: UInt = #line){
        expectFileAtPathToExist("index.html", at: outputURL, file: file, line: line)
        expectFileAtPathToExist("standalone/note/archived-note.html", at: outputURL, file: file, line: line)
        expectFileAtPathToExist("standalone/note/encrypted-note.html", at: outputURL, file: file, line: line)
        expectFileAtPathToExist("standalone/note/note-with-done-tasks.html", at: outputURL, file: file, line: line)
        expectFileAtPathToExist("standalone/note/note-with-file.html", at: outputURL, file: file, line: line)
        expectFileAtPathToExist("standalone/note/note-with-source-code.html", at: outputURL, file: file, line: line)
        expectFileAtPathToExist("standalone/note/note-with-tag.html", at: outputURL, file: file, line: line)
        expectFileAtPathToExist("standalone/note/note-with-undone-tasks.html", at: outputURL, file: file, line: line)
        expectFileAtPathToExist("standalone/note/pinned-note.html", at: outputURL, file: file, line: line)
        expectFileAtPathToExist("standalone/note/regular-note.html", at: outputURL, file: file, line: line)
        expectFileAtPathToExist("standalone/note/trashed-note.html", at: outputURL, file: file, line: line)
        expectFileAtPathToExist("standalone/list/all.html", at: outputURL, file: file, line: line)
        expectFileAtPathToExist("standalone/list/archived.html", at: outputURL, file: file, line: line)
        expectFileAtPathToExist("standalone/list/tasks.html", at: outputURL, file: file, line: line)
        expectFileAtPathToExist("standalone/list/trashed.html", at: outputURL, file: file, line: line)
        expectFileAtPathToExist("standalone/tag/code.html", at: outputURL, file: file, line: line)
        expectFileAtPathToExist("standalone/tag/dev.html", at: outputURL, file: file, line: line)
        expectFileAtPathToExist("standalone/tag/sometag.html", at: outputURL, file: file, line: line)
        expectFileAtPathToExist("standalone/tag/sometag&nested.html", at: outputURL, file: file, line: line)
        expectFileAtPathToExist("standalone/tag/sometag&nested&nested.html", at: outputURL, file: file, line: line)
        expectFileAtPathToExist("assets/css", at: outputURL, file: file, line: line)
        expectFileAtPathToExist("assets/js", at: outputURL, file: file, line: line)

        expectFileWithHashToExist(parentFolder: "assets/css", fileNamePrefix: "theme-variables", at: outputURL, file: file, line: line)
        expectFileWithHashToExist(parentFolder: "assets/css", fileNamePrefix: "styles", at: outputURL, file: file, line: line)
        expectFileWithHashToExist(parentFolder: "assets/js", fileNamePrefix: "htmx", at: outputURL, file: file, line: line)
        expectFileWithHashToExist(parentFolder: "assets/js", fileNamePrefix: "hyperscript", at: outputURL, file: file, line: line)
        expectFileWithHashToExist(parentFolder: "assets/js", fileNamePrefix: "main", at: outputURL, file: file, line: line)
    }
    
    func expectFileWithHashToExist(parentFolder: String, fileNamePrefix: String, at outputURL: URL, file: StaticString = #filePath, line: UInt = #line) {
        
        do {
            let directoryURL = outputURL.appendingPathComponent(parentFolder)
            
            let contents = try FileManager.default.contentsOfDirectory(
                at: directoryURL,
                includingPropertiesForKeys: nil
            )
            
            let cssFile = contents.first {
                $0.lastPathComponent.hasPrefix(fileNamePrefix)
            }
            
            XCTAssertNotNil(cssFile, "Expected to find a '\(fileNamePrefix)-<hash>' file in \(directoryURL.path)", file: file, line: line)
        } catch {
            XCTFail(error.localizedDescription, file: file, line: line)
        }
    }
    
    func expectFileAtPathToExist(_ path: String, at directoryURL: URL, file: StaticString = #filePath, line: UInt = #line) {
        XCTAssert(FileManager.default.fileExists(atPath: directoryURL.appendingPathComponent(path).path))
    }
}


// MARK: - Helpers
private extension IntegrationTests {
    
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


// MARK: - My beloved asterisk
infix operator .*: AdditionPrecedence

@discardableResult
func .*<T>(lhs: T, rhs: (inout T) -> Void) -> T {
    var copy = lhs
    rhs(&copy)
    return copy
}
