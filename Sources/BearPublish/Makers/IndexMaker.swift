// © 2025  Cristian Felipe Patiño Rojas. Created on 9/6/25.
import BearDomain

public struct IndexMaker {
    
    public protocol Renderer {
        func render(title: String, notes: [NoteList], tags: [Tag]) -> String
    }
    
    public let notes: [NoteList]
    public let tags: [Tag]
    private let renderer: Renderer
    
    public init(notes: [NoteList], tags: [Tag], renderer: Renderer) {
        self.notes = notes
        self.tags = tags
        self.renderer = renderer
    }
    
    public func callAsFunction() -> Resource {
        let rendered = renderer.render(title: "Home", notes: notes, tags: tags)
        return Resource(filename: "index.html", contents: rendered)
    }
}
