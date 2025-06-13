// © 2025  Cristian Felipe Patiño Rojas. Created on 4/6/25.

import XCTest
import BearPublish

class ResourceWriterTests: XCTestCase {
    
    override func setUp() {
        try? FileManager.default.removeItem(at: testSpecificURL())
    }
    
    override func tearDown() {
        try? FileManager.default.removeItem(at: testSpecificURL())
    }
    
    func test() async throws {
        let tmpURL = testSpecificURL()
        let resource = Resource(filename: "index.html", contents: "hello world")
        let sut = ResourceWriter(resources: [resource], outputURL: tmpURL)
        try sut.execute()
        
        XCTAssertEqual(
            try String(contentsOf: tmpURL.appendingPathComponent(resource.filename)),
            resource.contents
        )
    }
    
    private func testSpecificURL() -> URL {
        cachesDirectory().appendingPathComponent("\(type(of: self))")
    }
    
    private func cachesDirectory() -> URL {
        return FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
    }
}

