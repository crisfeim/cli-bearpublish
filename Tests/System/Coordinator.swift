// © 2025  Cristian Felipe Patiño Rojas. Created on 4/6/25.


struct Coordinator {
    
    protocol IndexRenderer {
        func render(notes: [Note], tags: [Tag]) throws -> String
    }
    
    protocol NoteListRenderer {
        func render(_ notes: [Note]) throws -> String
    }
    
    protocol NotesProvider {
        func get(_ filter: NoteListFilter) throws -> [Note]
    }
    
    protocol TagsProvider {
        func get() throws -> [Tag]
    }
    
    let notesProvider: NotesProvider
    let tagsProvider: TagsProvider
    let indexRenderer: IndexRenderer
    let noteListRenderer: NoteListRenderer
    
    func getIndex() throws -> Resource {
        let notes    = try notesProvider.get(.all)
        let tags     = try tagsProvider.get()
        let contents = try indexRenderer.render(notes: notes, tags: tags)
        return Resource(filename: "index.html", contents: contents)
    }
    
    func getNotes(_ filter: NoteListFilter) throws -> Resource {
        let notes    = try notesProvider.get(filter)
        let contents = try noteListRenderer.render(notes)
        return Resource(filename: "lists/\(filter.rawValue).html", contents: contents)
    }
}
