// © 2025  Cristian Felipe Patiño Rojas. Created on 9/6/25.

import XCTest
import BearPublisherCLI

class ComposerTests: XCTestCase {
    
    func test() throws {
        let dbURL = Bundle.module.url(forResource: "database", withExtension: "sqlite")!
        XCTAssert(FileManager.default.fileExists(atPath: dbURL.path))
    }
}
