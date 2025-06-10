// © 2025  Cristian Felipe Patiño Rojas. Created on 9/6/25.

import Foundation
import BearWebUI
import BearDatabase
import BearDomain
import BearPublisherCLI

func make(dbPath: String, outputURL: URL) throws -> SSG {
    let bearDb = try BearDb(path: dbPath)
    
    let noteListProvider = DefaultNoteListProvider(bearDb: bearDb)
    let tagProvider = TagsProvider(bearDb: bearDb)
    let notesProvider = NotesProvider(bearDb: bearDb)
    
    let index = try IndexMaker(
        noteListProvider: noteListProvider,
        tagsProvider: tagProvider,
        renderer: IndexRenderer()
    )()
    
    let notes = try NoteDetailMaker(
        provider: notesProvider,
        renderer: NoteDetailRenderer(),
        router: Router.note
    )()
    
    let noteLists = try NoteListMaker(
        provider: noteListProvider,
        renderer: NoteListRenderer(),
        router: Router.list
    )()
    
    let tagsNoteList = try NoteListMaker(
        provider: TagsNoteListsProvider(bearDb: bearDb),
        renderer: NoteListRenderer(),
        router: Router.tag
    )()
   
    let pages = [index] + notes + noteLists + tagsNoteList
    
    let css = IndexHTML.css().map {
        Resource(filename: "assets/css/\($0.fileName)", contents: $0.content)
    }
    
    let js = IndexHTML.js().map {
        Resource(filename: "assets/js/\($0.fileName)", contents: $0.content)
    }
    
    let all = pages + css + js
    let ssg = SSG(resources: all, outputURL: outputURL)
    return ssg
}
