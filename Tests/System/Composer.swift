// © 2025  Cristian Felipe Patiño Rojas. Created on 9/6/25.

import Foundation

func make(dbPath: String, outputURL: URL) throws -> SSG {
    let bearDb = try BearDatabase(dbPath: dbPath)
    
    let indexMaker = IndexMaker(provider: bearDb, renderer: IndexRenderer())
    let notesDetailMaker = NoteDetailMaker(
        provider: bearDb,
        renderer: NoteDetailRenderer(),
        router: { "standalone/note/\($0).html" }
    )
    
//    let defaultNoteListMaker = NoteListMaker(
//        provider: NoteListDefaultAdapterProvider(bearDb: bearDb),
//        renderer: NoteListRenderer(),
//        router: {_ in ""}
//    )
//    
//    let taggedNoteListMaker = NoteListMaker(
//        provider: NoteListTaggedAdapterProvider(bearDb: bearDb),
//        renderer: NoteListRenderer(),
//        router: {_ in ""}
//    )
    
    let pages = [try indexMaker.make()]
    + (try notesDetailMaker.make())
//    + (try defaultNoteListMaker.make()
//    + (try taggedNoteListMaker.make()))
    
    let ssg = SSG(resources: pages, outputURL: outputURL)
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
        try fetchTags().map {
            Tag(
                name: $0.name,
                fullPath: $0.path,
                notesCount: $0.count,
                children: [], // @todo
                isPinned: $0.isPinned
            )
        }
    }
}

extension BearDatabase: NoteDetailMaker.Provider {
    func get() throws -> [BearDomain.Note] {
        try notes()
    }
}

struct NoteListDefaultAdapterProvider: NoteListMaker.Provider {
    let bearDb: BearDatabase
    
    func get() throws -> [NoteList] {[]}
}

struct NoteListTaggedAdapterProvider: NoteListMaker.Provider {
    let bearDb: BearDatabase
    
    func get() throws -> [NoteList] {[]}
}


