// © 2025  Cristian Felipe Patiño Rojas. Created on 9/6/25.

struct TaggedNoteListMaker {
    protocol Provider {
        func get() throws -> [TagNoteList]
    }
    
    protocol Renderer {
        func render(_ notes: [Note]) -> String
    }
    
    let provider: Provider
    let renderer: Renderer
    
    func make() throws -> [Resource] {
        try provider.get().map {
            Resource(
                filename: "standalone/tag/\($0.tag)",
                contents: renderer.render($0.notes)
            )
        }
    }
}
