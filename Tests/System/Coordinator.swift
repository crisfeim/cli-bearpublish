// © 2025  Cristian Felipe Patiño Rojas. Created on 4/6/25.



struct TagNoteList: Equatable {
    let tag: String
    let notes: [Note]
}


protocol IndexRenderer {
    func render(notes: [Note], tags: [Tag]) -> String
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


struct Coordinator {
    let notesProvider: NotesProvider
    let taggedNotesProvider: TaggedNotesProvider
    let tagsProvider: TagsProvider
    
    let indexRenderer: IndexRenderer
    let noteListRenderer: NoteListRenderer
    let noteDetailRenderer: NoteDetailRenderer
    
    func getIndex() throws -> Resource {
        let notes    = try notesProvider.get(.all)
        let tags     = try tagsProvider.get()
        let contents = try indexRenderer.render(notes: notes, tags: tags)
        return Resource(filename: "index.html", contents: contents)
    }
    
    func getNotes(_ filter: NoteListFilter) throws -> Resource {
        let notes    = try notesProvider.get(filter)
        let contents = try noteListRenderer.render(notes)
        return Resource(filename: "standalone/list/\(filter.rawValue).html", contents: contents)
    }
    
    func getTaggedNotes() throws -> [Resource] {
        try taggedNotesProvider.get().map {
           Resource(
                filename: "standalone/tag/" + $0.tag,
                contents: try noteListRenderer.render($0.notes)
            )
        }
    }
    
    func getNoteDetails() throws -> [Resource] {
        try notesProvider.get(.all).map {
            Resource(filename: "standalone/note/\($0.slug)", contents: noteDetailRenderer.render($0))
        }
    }
}
