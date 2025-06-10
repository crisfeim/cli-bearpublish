// © 2025  Cristian Felipe Patiño Rojas. Created on 9/6/25.
import BearDomain

struct IndexMaker {
    
    protocol NoteListProvider {
        func get() throws -> [NoteList]
    }
    
    protocol TagsProvider {
        func get() throws -> [Tag]
    }
    
    protocol Renderer {
        func render(notes: [NoteList], tags: [Tag]) -> String
    }
    
    let noteListProvider: NoteListProvider
    let tagsProvider: TagsProvider
    let renderer: Renderer
    
    func make() throws -> Resource {
        let notes = try noteListProvider.get()
        let tags = try tagsProvider.get()
        let rendered = renderer.render(notes: notes, tags: tags)
        return Resource(filename: "index.html", contents: rendered)
    }
}
