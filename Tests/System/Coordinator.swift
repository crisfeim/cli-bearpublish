// © 2025  Cristian Felipe Patiño Rojas. Created on 4/6/25.



struct TagNoteList: Equatable {
    let tag: String
    let notes: [Note]
}

struct FilteredNoteList: Equatable {
    let filter: String
    let slug: String
    let notes: [Note]
}

protocol NoteListRenderer {
    func render(_ notes: [Note]) -> String
}

protocol NoteDetailRenderer {
    func render(_ note: Note) -> String
}

protocol NotesProvider {
    func get(_ filter: NoteListFilter) throws -> [Note]
}

protocol TaggedNotesProvider {
    func get() throws -> [TagNoteList]
}

protocol TagsProvider {
    func get() throws -> [Tag]
}
