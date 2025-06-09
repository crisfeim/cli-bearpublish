// © 2025  Cristian Felipe Patiño Rojas. Created on 9/6/25.

import XCTest
import BearPublisherCLI

class ComposerTests: XCTestCase {
    
    func test_copyBearDatabase() throws {
        
        let destinationPath = NSString(string: "~/Library/Containers/lat.cristian.Renard/Data/Applications/").expandingTildeInPath
        
        try copyBearDatabase(destinationPath: destinationPath, filename: "database.sqlite")
        
        XCTAssert(FileManager.default.fileExists(atPath: NSString(string: "\(destinationPath)/database.sqlite").expandingTildeInPath))
    }
}
