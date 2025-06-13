// © 2025  Cristian Felipe Patiño Rojas. Created on 12/6/25.

import XCTest
@testable import BearPublishCLI


class CLITests: XCTestCase {

    private var dbPath: String {
        Bundle.module.url(forResource: "database", withExtension: "sqlite")!.path
    }

    func test() async throws {
        let cli = try BearPublisherCLI.parse([
            "--db-path", dbPath,
            "--output-path", testSpecificURL().path
        ])
        try await cli.run()

        expectFileAtPathToExist("index.html")
    }
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
        cachesDirectory().appendingPathComponent("bearpublisher-cli")
    }
}


import ArgumentParser

import BearDatabase

struct CLI: AsyncParsableCommand {
    @Option(name: .shortAndLong) var input: String
    @Option(name: .shortAndLong) var output: String
    @Option(name: .shortAndLong) var siteTitle: String

    func run() async throws {
        
    }
}
