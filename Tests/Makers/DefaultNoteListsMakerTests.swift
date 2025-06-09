// © 2025  Cristian Felipe Patiño Rojas. Created on 3/6/25.

import XCTest



class DefaultNoteListsMakerTests: XCTestCase {

    typealias SUT = DefaultNoteListsMaker
    func test_make_deliversRenderedDefaultNoteLists() throws {
        let provider = ProviderStub(stubNotes: [
            FilteredNoteList(filter: "All notes", slug: "all", notes: [anyNote()])
        ])
        
        let renderer = RendererSpy(result: "any note list rendered content")
        let sut = makeSUT(provider: provider, renderer: renderer)
        
        let resources = try sut.make()
        
        let expectedResources = [Resource(
            filename: "standalone/list/all.html",
            contents: "any note list rendered content"
        )]
        
        XCTAssertEqual(resources, expectedResources)
        XCTAssertEqual(renderer.capturedNotes, [anyNote()])
    }
}

// MARK: - Helpers
private extension DefaultNoteListsMakerTests {
    
    func makeSUT(provider: SUT.Provider, renderer: SUT.Renderer) -> SUT {
        SUT(provider: provider, renderer: renderer)
    }
    
    struct ProviderStub: SUT.Provider {
        let stubNotes: [FilteredNoteList]
    
        func get() throws -> [FilteredNoteList] {
            stubNotes
        }
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
    
    func anyTag() -> Tag {
        Tag(name: "any tag")
    }
    
}
