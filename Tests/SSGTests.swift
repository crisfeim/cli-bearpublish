// © 2025  Cristian Felipe Patiño Rojas. Created on 4/6/25.

import XCTest

class SSGTests: XCTestCase {
   
    struct SSG {
        let resources: [Resource]
        let outputURL: URL
        
        func build() throws {
            try createOutputFolderIfNeeded()
            try resources.forEach {
                let url = outputURL.appendingPathComponent($0.filename)
                try $0.contents.write(to: url, atomically: true, encoding: .utf8)
            }
        }
        
        func createOutputFolderIfNeeded() throws {
            try FileManager.default.createDirectory(at: outputURL, withIntermediateDirectories: true)
        }
    }
    
    struct Resource {
        let filename: String
        let contents: String
    }
    
    override func setUp() {
        setupEmptyStoreState()
    }
    
    override func tearDown() {
        undoStoreSideEffects()
    }
    
    func test() throws {
        let tmpURL = testSpecificURL()
        let resource = Resource(filename: "index.html", contents: "hello world")
        let sut = SSG(resources: [resource], outputURL: tmpURL)
        try sut.build()
        
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
    
    private func setupEmptyStoreState() {
        try? deleteStoreArtifacts()
    }
    
    private func undoStoreSideEffects() {
       try? deleteStoreArtifacts()
    }
    
    private func deleteStoreArtifacts() throws{
        try FileManager.default.removeItem(at: testSpecificURL())
    }
}

