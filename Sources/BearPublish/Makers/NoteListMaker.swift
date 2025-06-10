// © 2025  Cristian Felipe Patiño Rojas. Created on 9/6/25.
import BearDomain

public struct NoteListMaker {
    
    public protocol Renderer {
        func render(_ notes: NoteList) -> String
    }
    
    public typealias Router = (String) -> String
    
    public let lists: [NoteList]
    private let renderer: Renderer
    private let router: Router
    
    public init(lists: [NoteList], renderer: Renderer, router: @escaping Router) {
        self.lists = lists
        self.renderer = renderer
        self.router = router
    }
    
    public func callAsFunction() throws -> [Resource] {
        lists.map {
            Resource(
                filename: router($0.slug),
                contents: renderer.render($0)
            )
        }
    }
}
