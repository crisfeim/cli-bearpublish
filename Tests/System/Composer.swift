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
}

func make(dbPath: String, outputURL: URL) throws -> BearSite {
    let bearDb = try BearDb(path: dbPath)
    
    let noteListProvider = DefaultNoteListProvider(bearDb: bearDb)
    let tagProvider = TagsProvider(bearDb: bearDb)
    let notesProvider = NotesProvider(bearDb: bearDb)
    
    let index = try IndexMaker(
        noteListProvider: noteListProvider,
        tagsProvider: tagProvider,
        renderer: IndexRenderer()
    )()
    
    let notes = try NotesMaker(
        provider: notesProvider,
        renderer: NoteRenderer(),
        router: Router.note
    )()
    
    let noteLists = try NoteListMaker(
        provider: noteListProvider,
        renderer: NoteListRenderer(),
        router: Router.list
    )()
    
    let noteListsForTags = try NoteListMaker(
        provider: TagsNoteListsProvider(bearDb: bearDb),
        renderer: NoteListRenderer(),
        router: Router.tag
    )()
   
    
    let `static` = IndexHTML.static().map(ResourceMapper.map)
    
    return BearSite(
        index: index,
        notes: notes,
        noteLists: noteLists,
        noteListsForTags: noteListsForTags,
        static: `static`
    )
}
