// © 2025  Cristian Felipe Patiño Rojas. Created on 9/6/25.

import Foundation
import BearWebUI
import BearDatabase
import BearDomain
import BearPublisherCLI

func make(dbPath: String, outputURL: URL) throws -> SSG {
    let bearDb = try BearDb(path: dbPath)
    
    let noteListProvider = NoteListDefaultAdapterProvider(bearDb: bearDb)
    
    let index = try IndexMaker(
        noteListProvider: noteListProvider,
        tagsProvider: bearDb,
        renderer: IndexRenderer()
    )()
    
    let notes = try NoteDetailMaker(
        provider: bearDb,
        renderer: NoteDetailRenderer(),
        router: Router.note
    )()
    
    let notesByFilter = try NoteListMaker(
        provider: noteListProvider,
        renderer: NoteListRenderer(),
        router: Router.list
    )()
    
    let notesByTags = try NoteListMaker(
        provider: NoteListTaggedAdapterProvider(bearDb: bearDb),
        renderer: NoteListRenderer(),
        router: Router.tag
    )()
   
    let pages = [index] + notes + notesByFilter + notesByTags
    
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


extension BearDb: IndexMaker.TagsProvider {
    
    func get() throws -> [BearDomain.Tag] {
        try fetchTagTree().map(HasthagMapper.map)
    }
}

extension BearDb: NoteDetailMaker.Provider {
    func get() throws -> [BearDomain.Note] {
        try fetchNotes().map(NoteMapper.map)
    }
}

struct NoteListDefaultAdapterProvider: NoteListMaker.Provider, IndexMaker.NoteListProvider {
    let bearDb: BearDb
    
    func get() throws -> [NoteList] {
        let all      = try bearDb.fetchAll().map(NoteMapper.map)
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

struct NoteListTaggedAdapterProvider: NoteListMaker.Provider {
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




