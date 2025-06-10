// © 2025  Cristian Felipe Patiño Rojas. Created on 10/6/25.


import Foundation
import BearWebUI
import BearDatabase
import BearDomain

public struct BearSite {
    public let index: IndexMaker
    public let notes: NotesMaker
    public let listsByCategory: NoteListMaker
    public let listsByHashtag: NoteListMaker
    public let assets: [Resource]
    public let outputURL: URL
    
    public init(index: IndexMaker, notes: NotesMaker, listsByCategory: NoteListMaker, listsByHashtag: NoteListMaker, assets: [Resource], outputURL: URL) {
        self.index = index
        self.notes = notes
        self.listsByCategory = listsByCategory
        self.listsByHashtag = listsByHashtag
        self.assets = assets
        self.outputURL = outputURL
    }
}

extension BearSite: @unchecked Sendable {
    private func cleanOutputFolder() {
        try? FileManager.default.removeItem(at: outputURL)
    }
    
    public func build() async throws {
        cleanOutputFolder()
        async let writeIndex: () = ResourceWriter(resources: [index()], outputURL: outputURL).build()
        async let writeNotes: () = ResourceWriter(resources: notes(), outputURL: outputURL).build()
        async let writeCategoryLists: () = ResourceWriter(resources: try listsByCategory(), outputURL: outputURL).build()
        async let writeHashtagLists: () = ResourceWriter(resources: try listsByHashtag(), outputURL: outputURL).build()
        async let writeAssets: () = ResourceWriter(resources: assets, outputURL: outputURL).build()
        
        _ = try await [writeIndex, writeNotes, writeCategoryLists, writeHashtagLists, writeAssets]
    }
}
