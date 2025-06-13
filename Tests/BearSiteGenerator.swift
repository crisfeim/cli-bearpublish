// © 2025  Cristian Felipe Patiño Rojas. Created on 13/6/25.

import XCTest
import BearPublish

struct BearSiteGenerator: @unchecked Sendable {
    let site: BearRenderedSite
    let outputURL: URL
    
    private func cleanOutputFolder() {
        try? FileManager.default.removeItem(at: outputURL)
    }

     func execute() async throws {
        cleanOutputFolder()
         async let writeIndex: () = write([site.index])
         async let writeNotes: () = write(site.notes)
         async let writeCategoryLists: () = write(site.listsByCategory)
         async let writeHashtagLists: () = write(site.listsByTag)
         async let writeAssets: () = write(site.assets)
        
        _ = try await [writeIndex, writeNotes, writeCategoryLists, writeHashtagLists, writeAssets]
    }
    
    private func write(_ resources: [Resource]) throws {
        try ResourceWriter(resources: resources, outputURL: outputURL).write()
    }
}
