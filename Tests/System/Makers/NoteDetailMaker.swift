// © 2025  Cristian Felipe Patiño Rojas. Created on 9/6/25.

struct NoteDetailMaker {
    protocol Provider {
        func get() throws -> [Note]
    }
    
    protocol Renderer {
        func render(_ note: Note) -> String
    }
    
    let provider: Provider
    let renderer: Renderer
    
    func make() throws -> [Resource] {
        try provider.get().map {
            Resource(
                filename: "standalone/note/\($0.slug)",
                contents: renderer.render($0)
            )
        }
    }
}
