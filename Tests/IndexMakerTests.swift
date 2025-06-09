// © 2025  Cristian Felipe Patiño Rojas. Created on 9/6/25.

import XCTest
import BearPublisherCLI

class IndexMakerTests: XCTestCase {
    
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
    
    func test_make_deliversRenderedIndexWithProvidedNotesAndTags() throws {
        
        let provider = ProviderStub(stubNotes: [anyNote()], stubTags: [anyTag()])
        let renderer = RendererSpy(result: "any renderer")
        
        let sut = makeSUT(provider: provider,  renderer: renderer)
        
        let index = try sut.make()
        
        let expectedIndex = Resource(filename: "index.html", contents: "any renderer")
        
        XCTAssertEqual(index, expectedIndex)
        XCTAssertEqual(renderer.capturedTags, [anyTag()])
        XCTAssertEqual(renderer.capturedNotes, [anyNote()])
    }
    
    func makeSUT(provider: IndexMaker.Provider, renderer: IndexMaker.Renderer) -> IndexMaker {
         IndexMaker(
            provider: provider,
            renderer: renderer
        )
    }
    
    struct ProviderStub: IndexMaker.Provider {
        let stubNotes: [Note]
        let stubTags: [Tag]
        
        func notes() throws -> [Note] { stubNotes }
        func tags() throws -> [Tag] { stubTags }
    }
    
    class RendererSpy: IndexMaker.Renderer {
        private let result: String
        private(set) var capturedNotes = [Note]()
        private(set) var capturedTags  = [Tag]()
        
        init(result: String) {
            self.result = result
        }
        
        func render(notes: [Note], tags: [Tag]) -> String {
            capturedNotes = notes
            capturedTags  = tags
            return result
        }
    }
    
    func anyNote() -> Note {
        Note(content: "any content", slug: "any-slug")
    }
    
    func anyTag() -> Tag {
        Tag(name: "any tag")
    }
}
