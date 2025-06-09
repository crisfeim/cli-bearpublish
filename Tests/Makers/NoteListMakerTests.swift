// © 2025  Cristian Felipe Patiño Rojas. Created on 9/6/25.

import XCTest

class NoteListMakerTests: XCTestCase {
    
    typealias SUT = NoteListMaker
    
    func test_make_deliversRenderedTaggedNoteLists() throws {
        
        let provider = ProviderStub(stub: [
            NoteList(title: "Any tag", slug: "any-tag", notes: [anyNote()])
        ])
        let renderer = RendererSpy(result: "any rendered content")
        let router: SUT.Router = { "standalone/tag/\($0)" }
        
        let sut = makeSUT(provider: provider, renderer: renderer, router: router)
        let resources = try sut.make()
        let expected = [Resource(filename: "standalone/tag/any-tag", contents: "any rendered content")]
        
        XCTAssertEqual(resources, expected)
        XCTAssertEqual(renderer.capturedNotes, [anyNote()])
    }
    
    
    func makeSUT(provider: SUT.Provider, renderer: SUT.Renderer, router: @escaping SUT.Router) -> SUT {
        SUT(provider: provider, renderer: renderer, router: router)
    }
    
    
    struct ProviderStub: SUT.Provider {
        let stub: [NoteList]
        func get() throws -> [NoteList] { stub }
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
