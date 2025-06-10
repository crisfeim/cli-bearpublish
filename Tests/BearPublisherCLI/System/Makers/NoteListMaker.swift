// © 2025  Cristian Felipe Patiño Rojas. Created on 9/6/25.
import BearDomain

struct NoteListMaker {
    
    protocol Renderer {
        func render(_ notes: NoteList) -> String
    }
    
    typealias Router = (String) -> String
    
    let lists: [NoteList]
    let renderer: Renderer
    let router: Router
    
    func callAsFunction() throws -> [Resource] {
        lists.map {
            Resource(
                filename: router($0.slug),
                contents: renderer.render($0)
            )
        }
    }
}
