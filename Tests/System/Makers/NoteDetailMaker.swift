// © 2025  Cristian Felipe Patiño Rojas. Created on 9/6/25.
import BearDomain

struct NoteDetailMaker {
    protocol Provider {
        func get() throws -> [Note]
    }
    
    protocol Renderer {
        func render(_ note: Note) -> String
    }
    
    typealias Router = (String) -> String
    let provider: Provider
    let renderer: Renderer
    let router: Router
    
    func make() throws -> [Resource] {
        try provider.get().map {
            Resource(
                filename: router($0.slug),
                contents: renderer.render($0)
            )
        }
    }
}
