// © 2025  Cristian Felipe Patiño Rojas. Created on 9/6/25.
import BearDomain

struct IndexMaker {
    
    protocol Renderer {
        func render(notes: [NoteList], tags: [Tag]) -> String
    }
    
    let notes: [NoteList]
    let tags: [Tag]
    let renderer: Renderer
    
    func callAsFunction() -> Resource {
        let rendered = renderer.render(notes: notes, tags: tags)
        return Resource(filename: "index.html", contents: rendered)
    }
}
