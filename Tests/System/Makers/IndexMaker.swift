// © 2025  Cristian Felipe Patiño Rojas. Created on 9/6/25.

struct IndexMaker {
        protocol Provider {
            func notes() throws -> [Note]
            func tags() throws -> [Tag]
        }
        
        protocol Renderer {
            func render(notes: [Note], tags: [Tag]) -> String
        }
        
        let provider: Provider
        let renderer: Renderer
        
        func make() throws -> Resource {
            let notes = try provider.notes()
            let tags = try provider.tags()
            let rendered = renderer.render(notes: notes, tags: tags)
            return Resource(filename: "index.html", contents: rendered)
        }
    }
