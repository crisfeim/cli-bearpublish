// © 2025  Cristian Felipe Patiño Rojas. Created on 9/6/25.

import XCTest
import BearDomain

class IndexMakerTests: XCTestCase {
    
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
        Note(
            id: 0,
            title: "any note",
            slug: "any-slug",
            isPinned: false,
            isEncrypted: false,
            isEmpty: false,
            subtitle: "any subtitle",
            creationDate: nil,
            modificationDate: nil,
            content: "any content"
        )
    }
    
    func anyTag() -> Tag {
        Tag(name: "any tag", fullPath: "any-tag", notesCount: 0, children: [], isPinned: false)
    }
}
