// © 2025  Cristian Felipe Patiño Rojas. Created on 9/6/25.

import Foundation
import BearWebUI
import BearDatabase
import BearDomain
import BearPublisherCLI

struct BearSite {
    let index: Resource
    let notes: [Resource]
    let noteLists: [Resource]
    let noteListsForTags: [Resource]
    let `static`: [Resource]
    
    let outputURL: URL
}

extension BearSite {
    func build() async throws {
        async let writeIndex: () = ResourceWriter(resources: [index], outputURL: outputURL).build()
        async let writeNotes: () = ResourceWriter(resources: notes, outputURL: outputURL).build()
        async let writeNoteLists: () = ResourceWriter(resources: noteLists, outputURL: outputURL).build()
        async let writeNoteListsForTags: () = ResourceWriter(resources: noteListsForTags, outputURL: outputURL).build()
        async let writeStatic: () = ResourceWriter(resources: `static`, outputURL: outputURL).build()
        
        _ = try await (writeIndex, writeNotes, writeNoteLists, writeNoteListsForTags, writeStatic)
    }
}

func make(dbPath: String, outputURL: URL) throws -> (
    index: IndexMaker,
    notes: NotesMaker,
    noteLists: NoteListMaker,
    noteListsForTags: NoteListMaker,
    `static`: [Resource]
) {
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
        provider: noteListProvider,
        renderer: NoteListRenderer(),
        router: Router.list
    )
    
    let noteListsForTags = NoteListMaker(
        provider: TagsNoteListsProvider(bearDb: bearDb),
        renderer: NoteListRenderer(),
        router: Router.tag
    )
   
    
    let `static` = IndexHTML.static().map(ResourceMapper.map)
    
    return (index: index, notes: notes, noteLists: noteLists, noteListsForTags: noteListsForTags, static: `static`)
}
