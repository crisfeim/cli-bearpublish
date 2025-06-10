// © 2025  Cristian Felipe Patiño Rojas. Created on 9/6/25.
import BearDomain

public struct NotesMaker {
    
   public protocol Renderer {
        func render(_ note: Note) -> String
    }
    
    public typealias Router = (String) -> String
    private let notes: [Note]
    private let renderer: Renderer
    private let router: Router
    
    public init(notes: [Note], renderer: Renderer, router: @escaping Router) {
        self.notes = notes
        self.renderer = renderer
        self.router = router
    }
    
    public func callAsFunction() -> [Resource] {
        notes.map {
            Resource(
                filename: router($0.slug),
                contents: renderer.render($0)
            )
        }
    }
}
