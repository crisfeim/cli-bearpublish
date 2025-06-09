// © 2025  Cristian Felipe Patiño Rojas. Created on 9/6/25.

import Foundation

import BearWebUI

func make(dbPath: String, outputURL: URL) throws -> SSG {
    let bearDb = try BearDb(path: dbPath)
    
    let index = try IndexMaker(
        provider: bearDb,
        renderer: IndexRenderer()
    ).make()
    
    let notes = try NoteDetailMaker(
        provider: bearDb,
        renderer: NoteDetailRenderer(),
        router: Router.note
    ).make()
    
    let defaultLists = try NoteListMaker(
        provider: NoteListDefaultAdapterProvider(bearDb: bearDb),
        renderer: NoteListRenderer(),
        router: Router.list
    ).make()
    
    let tagNoteLists = try NoteListMaker(
        provider: NoteListTaggedAdapterProvider(bearDb: bearDb),
        renderer: NoteListRenderer(),
        router: Router.tag
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
        try bearDb.fetchTagTree().flatMap(makeNoteLists)
    }
    
    private func makeNoteLists(from hashtag: Hashtag) throws -> [NoteList] {
        let notes = try bearDb.fetchNotes(with: hashtag.name).map(NoteMapper.map)
        let current = NoteList(
            title: hashtag.name,
            slug: hashtag.path.replacingOccurrences(of: "/", with: "&"),
            notes: notes
        )
        let childrenLists = try hashtag.children.flatMap(makeNoteLists)
        return [current] + childrenLists
    }
}




