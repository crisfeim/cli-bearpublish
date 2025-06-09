// © 2025  Cristian Felipe Patiño Rojas. Created on 9/6/25.

import Foundation

import BearWebUI

func make(dbPath: String, outputURL: URL) throws -> SSG {
    let bearDb = try BearDatabase(dbPath: dbPath)
    
    let indexMaker = IndexMaker(provider: bearDb, renderer: IndexRenderer())
    let notesDetailMaker = NoteDetailMaker(
        provider: bearDb,
        renderer: NoteDetailRenderer(),
        router: { "standalone/note/\($0).html" }
    )
    
    let defaultNoteListMaker = NoteListMaker(
        provider: NoteListDefaultAdapterProvider(bearDb: bearDb),
        renderer: NoteListRenderer(),
        router: { "standalone/list/\($0).html"}
    )
    
    let tagNoteListMaker = NoteListMaker(
        provider: NoteListTaggedAdapterProvider(bearDb: bearDb),
        renderer: NoteListRenderer(),
        router: { "standalone/tag/\($0).html" }
    )
   
    let index = try indexMaker.make()
    let notes = try notesDetailMaker.make()
    let lists = try defaultNoteListMaker.make() + (try tagNoteListMaker.make())
    
    let pages = [index] + notes + lists
    
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

extension BearDatabase: IndexMaker.Provider {
    func notes() throws -> [BearDomain.Note] {
        try fetchAll().map {
            Note(
                id: $0.id,
                title: $0.title ?? "@todo",
                slug: slugify($0.title ?? "New note"),
                isPinned: $0.isPinned,
                isEncrypted: $0.isEncrypted,
                isEmpty: $0.content?.isEmpty ?? true,
                subtitle: $0.subtitle ?? "",
                creationDate: $0.creationDate,
                modificationDate: $0.modificationDate,
                content: $0.content ?? ""
            )
        }
    }
    
    func tags() throws -> [BearDomain.Tag] {
        try fetchTagTree().map(HasthagMapper.map)
    }
}

extension BearDatabase: NoteDetailMaker.Provider {
    func get() throws -> [BearDomain.Note] {
        try notes()
    }
}

struct NoteListDefaultAdapterProvider: NoteListMaker.Provider {
    let bearDb: BearDatabase
    
    func get() throws -> [NoteList] {
        let archived = try bearDb.fetchArchived().map {
            BearDomain.Note(
                id: $0.id,
                title: $0.title ?? "New note",
                slug: slugify($0.title ?? "New note"),
                isPinned: $0.isPinned,
                isEncrypted: $0.isPinned,
                isEmpty: $0.content?.isEmpty ?? true,
                subtitle: $0.subtitle ?? "",
                creationDate: $0.creationDate,
                modificationDate: $0.modificationDate,
                content: $0.content ?? ""
            )
        }
        
        let tasks = try bearDb.fetchTasks().map {
            BearDomain.Note(
                id: $0.id,
                title: $0.title ?? "New note",
                slug: slugify($0.title ?? "New note"),
                isPinned: $0.isPinned,
                isEncrypted: $0.isPinned,
                isEmpty: $0.content?.isEmpty ?? true,
                subtitle: $0.subtitle ?? "",
                creationDate: $0.creationDate,
                modificationDate: $0.modificationDate,
                content: $0.content ?? ""
            )
        }
        
        return [
            NoteList(title: "Archived", slug: "archived", notes: archived),
            NoteList(title: "Tasks", slug: "tasks", notes: tasks)
        ]
    }
}

struct NoteListTaggedAdapterProvider: NoteListMaker.Provider {
    let bearDb: BearDatabase
    
    func get() throws -> [NoteList] {
        let tags = try bearDb.fetchTags()
        return try tags.map {
            let notes = try bearDb.fetchNotes(with: $0.name).map {
                BearDomain.Note(
                    id: $0.id,
                    title: $0.title ?? "New note",
                    slug: slugify($0.title ?? "New note"),
                    isPinned: $0.isPinned,
                    isEncrypted: $0.isPinned,
                    isEmpty: $0.content?.isEmpty ?? true,
                    subtitle: $0.subtitle ?? "",
                    creationDate: $0.creationDate,
                    modificationDate: $0.modificationDate,
                    content: $0.content ?? ""
                )
            }
            
            return NoteList(title: $0.name, slug: slugify($0.name), notes: notes)
        }
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


