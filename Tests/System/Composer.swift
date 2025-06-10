// © 2025  Cristian Felipe Patiño Rojas. Created on 9/6/25.

import Foundation
import BearWebUI
import BearDatabase
import BearDomain
import BearPublisherCLI

struct BearSite {
    let index: IndexMaker
    let notes: NotesMaker
    let listsByCategory: NoteListMaker
    let listsByHashtag: NoteListMaker
    let assets: [Resource]
    let outputURL: URL
}

extension BearSite {
    
    func build() async throws {
        let indexResource = index()
        let notesResources = try notes()
        let categoryLists = try listsByCategory()
        let hashtagLists = try listsByHashtag()
        let staticAssets =  assets
        let outputURL = outputURL
        
        async let writeIndex: () = ResourceWriter(resources: [indexResource], outputURL: outputURL).build()
        async let writeNotes: () = ResourceWriter(resources: notesResources, outputURL: outputURL).build()
        async let writeCategoryLists: () = ResourceWriter(resources: categoryLists, outputURL: outputURL).build()
        async let writeHashtagLists: () = ResourceWriter(resources: hashtagLists, outputURL: outputURL).build()
        async let writeAssets: () = ResourceWriter(resources: staticAssets, outputURL: outputURL).build()
        
        _ = try await [writeIndex, writeNotes, writeCategoryLists, writeHashtagLists, writeAssets]
    }
}

func makeSite(dbPath: String, outputURL: URL) throws -> BearSite {
    let bearDb = try BearDb(path: dbPath)
    
    let noteListProvider = DefaultNoteListProvider(bearDb: bearDb)
    let tagProvider = TagsProvider(bearDb: bearDb)
    let notesProvider = NotesProvider(bearDb: bearDb)
    
    let index = IndexMaker(
        notes: try noteListProvider.get(),
        tags: try tagProvider.get(),
        renderer: IndexRenderer()
    )
    
    let notes = NotesMaker(
        provider: notesProvider,
        renderer: NoteRenderer(),
        router: Router.note
    )
    
    let noteLists = NoteListMaker(
        lists: try noteListProvider.get(),
        renderer: NoteListRenderer(),
        router: Router.list
    )
    
    let noteListsForTags = NoteListMaker(
        lists: try TagsNoteListsProvider(bearDb: bearDb).get(),
        renderer: NoteListRenderer(),
        router: Router.tag
    )
    
    let `static` = IndexHTML.static().map(ResourceMapper.map)
    
    return BearSite(
        index: index,
        notes: notes,
        listsByCategory: noteLists,
        listsByHashtag: noteListsForTags,
        assets: `static`,
        outputURL: outputURL
    )
}
