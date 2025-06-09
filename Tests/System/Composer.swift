// © 2025  Cristian Felipe Patiño Rojas. Created on 9/6/25.

import Foundation

import BearWebUI

func make(dbPath: String, outputURL: URL) throws -> SSG {
    let bearDb = try BearDb(path: dbPath)
    
    let index = try IndexMaker(provider: bearDb, renderer: IndexRenderer()).make()
    let notes = try NoteDetailMaker(
        provider: bearDb,
        renderer: NoteDetailRenderer(),
        router: { "standalone/note/\($0).html" }
    ).make()
    
    let defaultLists = try NoteListMaker(
        provider: NoteListDefaultAdapterProvider(bearDb: bearDb),
        renderer: NoteListRenderer(),
        router: { "standalone/list/\($0).html"}
    ).make()
    
    let tagNoteLists = try NoteListMaker(
        provider: NoteListTaggedAdapterProvider(bearDb: bearDb),
        renderer: NoteListRenderer(),
        router: { "standalone/tag/\($0).html" }
    ).make()
   
    
    let pages = [index] + notes + defaultLists + tagNoteLists
    
    let css = IndexHTML.css().map {
        Resource(filename: "assets/css/\($0.fileName)", contents: $0.content)
    }
    
    let js = ([IndexHTML.bodyJS()] + IndexHTML.headJS()).map {
        Resource(filename: "assets/js/\($0.fileName)", contents: $0.content)
    }
    
    let all = pages + css + js
    let ssg = SSG(resources: all, outputURL: outputURL)
    return ssg
}

import BearDatabase
import BearDomain
import BearPublisherCLI

extension BearDb: IndexMaker.Provider {
    func notes() throws -> [BearDomain.Note] {
        try fetchAll().map(NoteMapper.map)
    }
    
    func tags() throws -> [BearDomain.Tag] {
        try fetchTagTree().map(HasthagMapper.map)
    }
}

extension BearDb: NoteDetailMaker.Provider {
    func get() throws -> [BearDomain.Note] {
        try notes()
    }
}

struct NoteListDefaultAdapterProvider: NoteListMaker.Provider {
    let bearDb: BearDb
    
    func get() throws -> [NoteList] {
        let archived = try bearDb.fetchArchived().map(NoteMapper.map)
        let tasks    = try bearDb.fetchTasks().map(NoteMapper.map)
        
        return [
            NoteList(title: "Archived", slug: "archived", notes: archived),
            NoteList(title: "Tasks", slug: "tasks", notes: tasks)
        ]
    }
}

struct NoteListTaggedAdapterProvider: NoteListMaker.Provider {
    let bearDb: BearDb
    
    func get() throws -> [NoteList] {
        let tags = try bearDb.fetchTags()
        return try tags.map {
            let notes = try bearDb.fetchNotes(with: $0.name).map(NoteMapper.map)
            return NoteList(title: $0.name, slug: slugify($0.name), notes: notes)
        }
    }
}

enum NoteMapper {
    static func map(_ note: BearDatabase.Note) -> BearDomain.Note {
        Note(
            id: note.id,
            title: note.title ?? "New note",
            slug: slugify(note.title ?? "New note"),
            isPinned: note.isPinned,
            isEncrypted: note.isEncrypted,
            isEmpty: note.content?.isEmpty ?? true,
            subtitle: note.subtitle ?? "",
            creationDate: note.creationDate,
            modificationDate: note.modificationDate,
            content: note.content ?? ""
        )
    }
}

enum HasthagMapper {
    static func map(_ hashtag: Hashtag) -> Tag {
        Tag(
            name: hashtag.name,
            fullPath: hashtag.path,
            notesCount: hashtag.count,
            children: hashtag.children.map(Self.map),
            isPinned: hashtag.isPinned
        )
    }
}


