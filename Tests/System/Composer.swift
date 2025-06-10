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


struct TagsProvider: IndexMaker.TagsProvider {
    let bearDb: BearDb
    func get() throws -> [Tag] {
        try bearDb.fetchTagTree().map(HasthagMapper.map)
    }
}

struct NotesProvider: NoteDetailMaker.Provider {
    let bearDb: BearDb
    func get() throws -> [BearDomain.Note] {
        try bearDb.fetchAll().map(NoteMapper.map)
    }
}

struct DefaultNoteListProvider: NoteListMaker.Provider, IndexMaker.NoteListProvider {
    let bearDb: BearDb
    
    func get() throws -> [NoteList] {
        let all      = try bearDb.fetchNotes().map(NoteMapper.map)
        let archived = try bearDb.fetchArchived().map(NoteMapper.map)
        let tasks    = try bearDb.fetchTasks().map(NoteMapper.map)
        let trashed  = try bearDb.fetchTrashed().map(NoteMapper.map)
        return [
            NoteList(title: "All", slug: "all", notes: all),
            NoteList(title: "Archived", slug: "archived", notes: archived),
            NoteList(title: "Tasks", slug: "tasks", notes: tasks),
            NoteList(title: "Trashed", slug: "trashed", notes: trashed)
        ]
    }
}

struct TagsNoteListsProvider: NoteListMaker.Provider {
    let bearDb: BearDb
    
    func get() throws -> [NoteList] {
        try bearDb.fetchTagTree().flatMap(makeNoteLists)
    }
    
    private func makeNoteLists(from hashtag: Hashtag) throws -> [NoteList] {
        let notes = try bearDb.fetchNotes(with: hashtag.path).map(NoteMapper.map)
        let current = NoteList(
            title: hashtag.name,
            slug: hashtag.path.replacingOccurrences(of: "/", with: "&"),
            notes: notes
        )
        let childrenLists = try hashtag.children.flatMap(makeNoteLists)
        return [current] + childrenLists
    }
}




