// © 2025  Cristian Felipe Patiño Rojas. Created on 9/6/25.

struct NoteListMaker {
    protocol Provider {
        func get() throws -> [NoteList]
    }
    
    protocol Renderer {
        func render(_ notes: [Note]) -> String
    }
    
    typealias Router = (String) -> String
    
    let provider: Provider
    let renderer: Renderer
    let router: Router
    
    func make() throws -> [Resource] {
        try provider.get().map {
            Resource(
                filename: router($0.slug),
                contents: renderer.render($0.notes)
            )
        }
    }
}
