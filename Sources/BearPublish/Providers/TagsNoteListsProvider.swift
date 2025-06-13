// © 2025  Cristian Felipe Patiño Rojas. Created on 10/6/25.


import BearWebUI
import BearDatabase
import BearDomain

struct TagsNoteListsProvider {
    let bearDb: BearDb
    
    func get() throws -> [NoteList] {
        try bearDb.fetchTagTree().flatMap(makeNoteLists)
    }
    
    private func makeNoteLists(from hashtag: DBTag) throws -> [NoteList] {
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
