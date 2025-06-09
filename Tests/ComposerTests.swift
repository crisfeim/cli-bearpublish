// © 2025  Cristian Felipe Patiño Rojas. Created on 9/6/25.

import XCTest
import BearPublisherCLI

class ComposerTests: XCTestCase {
    
    func test_copyBearDatabase() throws {
        
        try copyBearDatabase()
        XCTAssert(FileManager.default.fileExists(atPath: NSString(string: "~/Library/Containers/lat.cristian.Renard/Data/Applications/database.sqlite").expandingTildeInPath))
    }
}
