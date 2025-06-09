// © 2025  Cristian Felipe Patiño Rojas. Created on 9/6/25.

struct DefaultNoteListsMaker {
    protocol Provider {
        func get() throws -> [FilteredNoteList]
    }
    
    protocol Renderer {
        func render(_ notes: [Note]) -> String
    }
    
    let provider: Provider
    let renderer: Renderer
    
    func make() throws -> [Resource] {
        try provider.get().map {
            Resource(
                filename: "standalone/list/\($0.slug).html",
                contents: renderer.render($0.notes)
            )
        }
    }
}
