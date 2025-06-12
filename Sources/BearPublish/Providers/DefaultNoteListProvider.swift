// © 2025  Cristian Felipe Patiño Rojas. Created on 10/6/25.


import BearWebUI
import BearDatabase
import BearDomain

struct DefaultNoteListProvider {
    let bearDb: BearDb
    
    func get() throws -> [NoteList] {
        let all      = try bearDb.fetchNotes().map(NoteMapper.map)
        let archived = try bearDb.fetchArchived().map(NoteMapper.map)
        let tasks    = try bearDb.fetchTasks().map(NoteMapper.map)
        let trashed  = try bearDb.fetchTrashed().map(NoteMapper.map)
        let untagged = try bearDb.fetchUntagged().map(NoteMapper.map)
        return [
            NoteList(title: "All", slug: "all", notes: all),
            NoteList(title: "Archived", slug: "archived", notes: archived),
            NoteList(title: "Tasks", slug: "tasks", notes: tasks),
            NoteList(title: "Trashed", slug: "trashed", notes: trashed),
            NoteList(title: "Untagged", slug: "untagged", notes: untagged)
        ]
    }
}
