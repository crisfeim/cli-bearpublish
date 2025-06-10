// © 2025  Cristian Felipe Patiño Rojas. Created on 9/6/25.
import BearDomain

public struct NotesMaker {
    
    public protocol Parser {
        func parse(_ content: String) -> String
    }
    
    public protocol Renderer {
        func render(title: String, slug: String, content: String) -> String
    }
    
    public typealias Router = (String) -> String
    private let notes: [Note]
    private let parser: Parser
    private let renderer: Renderer
    private let router: Router
    
    public init(notes: [Note], parser: Parser, renderer: Renderer, router: @escaping Router) {
        self.notes = notes
        self.renderer = renderer
        self.router = router
        self.parser = parser
    }
    
    public func callAsFunction() -> [Resource] {
        notes.map {
            let parsedContent = parser.parse($0.content)
            return Resource(
                filename: router($0.slug),
                contents: renderer.render(title: $0.title, slug: $0.slug, content: parsedContent)
            )
        }
    }
}
