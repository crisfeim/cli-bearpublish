// © 2025  Cristian Felipe Patiño Rojas. Created on 9/6/25.

import XCTest

class TaggedNoteListMakerTests: XCTestCase {
    
    typealias SUT = TaggedNoteListMaker
    func test_make_deliversRenderedTaggedNoteLists() throws {
        
        let provider = ProviderStub(stub: [TagNoteList(tag: "any-tag", notes: [anyNote()])])
        let renderer = RendererSpy(result: "any rendered content")
        let sut = makeSUT(provider: provider, renderer: renderer)
        let resources = try sut.make()
        let expected = [Resource(filename: "standalone/tag/any-tag", contents: "any rendered content")]
        
        XCTAssertEqual(resources, expected)
        XCTAssertEqual(renderer.capturedNotes, [anyNote()])
    }
    
    
    func makeSUT(provider: SUT.Provider, renderer: SUT.Renderer) -> SUT {
        SUT(provider: provider, renderer: renderer)
    }
    
    
    struct ProviderStub: SUT.Provider {
        let stub: [TagNoteList]
        func get() throws -> [TagNoteList] { stub }
    }
    
    class RendererSpy: SUT.Renderer {
        
        private let result: String
        private(set) var capturedNotes = [Note]()
        init(result: String) {
            self.result = result
        }
        
        func render(_ notes: [Note]) -> String {
            capturedNotes = notes
            return result
        }
    }
    
    func anyNote() -> Note {
        Note(content: "any content", slug: "any-slug")
    }
}
