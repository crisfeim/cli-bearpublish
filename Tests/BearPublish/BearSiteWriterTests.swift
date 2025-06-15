// © 2025  Cristian Felipe Patiño Rojas. Created on 13/6/25.

import XCTest
import BearPublish

class BearSiteWriterTests: XCTestCase, OutputFilesystemTestCase {
    
    override func setUp() {
        try? FileManager.default.removeItem(at: testSpecificURL())
    }
    
    override func tearDown() {
        try? FileManager.default.removeItem(at: testSpecificURL())
    }
    
    func test_execute_writesSiteToOutputURL() async throws {
        let index = Resource(filename: "index.html", contents: "index contents")
        let notes = [Resource(filename: "notes/somenote.html", contents: "some note contents")]
        let listsByCategory = [
            Resource(filename: "list/somecategorylist.html", contents: "some category list contents")
        ]
        let listsByTag = [
            Resource(filename: "tag/sometaglist.html", contents: "some tag list contents")
        ]
        
        let assets = [
            Resource(filename: "css/somecss.css", contents: "css content"),
            Resource(filename: "js/somejs.js", contents: "js content"),
        ]
        
        let site = BearRenderedSite(
            index: index,
            notes: notes,
            listsByCategory: listsByCategory,
            listsByTag: listsByTag,
            assets: assets
        )

        let filesFolder = testSpecificURL().appendingPathComponent("filesFolder")
        let imagesFolder = testSpecificURL().appendingPathComponent("imagesFolder")
        
        try FileManager.default.createDirectory(at: filesFolder, withIntermediateDirectories: true)
        try FileManager.default.createDirectory(at: imagesFolder, withIntermediateDirectories: true)
        
        
        let sut = BearSiteGenerator(
            site: site,
            outputURL: outputFolder(),
            filesFolderURL: filesFolder,
            imagesFolderURL: imagesFolder,
        )
        
        try await sut.execute()
      
        expectFileAtPathToExist("index.html", at: outputFolder())
        expectFileAtPathToExist("notes/somenote.html", at: outputFolder())
        expectFileAtPathToExist("list/somecategorylist.html", at: outputFolder())
        expectFileAtPathToExist("tag/sometaglist.html", at: outputFolder())
        expectFileAtPathToExist("css/somecss.css", at: outputFolder())
        expectFileAtPathToExist("js/somejs.js", at: outputFolder())
    }
}
