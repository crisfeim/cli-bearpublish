// © 2025  Cristian Felipe Patiño Rojas. Created on 12/6/25.

import XCTest
@testable import BearPublishCLI


class CLITests: XCTestCase {

    private var dbPath: String {
        Bundle.module.url(forResource: "database", withExtension: "sqlite")!.path
    }

    func test() async throws {}
}

// MARK: - Helpers
private extension CLITests {
    func expectFileAtPathToExist(_ path: String, file: StaticString = #filePath, line: UInt = #line) {
        XCTAssert(FileManager.default.fileExists(atPath: testSpecificURL().appendingPathComponent(path).path))
    }

    func cachesDirectory() -> URL {
        return FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
    }

    func testSpecificURL() -> URL {
        cachesDirectory().appendingPathComponent("\(type(of: self))")
    }
}
