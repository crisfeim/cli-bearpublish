// © 2025  Cristian Felipe Patiño Rojas. Created on 9/6/25.
import BearDomain

public struct NotesMaker {
    public protocol Provider {
        func get() throws -> [Note]
    }
    
   public protocol Renderer {
        func render(_ note: Note) -> String
    }
    
    public typealias Router = (String) -> String
    let provider: Provider
    let renderer: Renderer
    let router: Router
    
    public init(provider: Provider, renderer: Renderer, router: @escaping Router) {
        self.provider = provider
        self.renderer = renderer
        self.router = router
    }
    
    public func callAsFunction() throws -> [Resource] {
        try provider.get().map {
            Resource(
                filename: router($0.slug),
                contents: renderer.render($0)
            )
        }
    }
}
