// © 2025  Cristian Felipe Patiño Rojas. Created on 9/6/25.

import XCTest

class NoteDetailMakerTests: XCTestCase {
    typealias SUT = NoteDetailMaker
    func test_make_deliversRenderedNoteDetails() throws {
        let provider = ProviderStub(notes: [anyNote()])
        let renderer = Renderer(result: "any note content")
        let router: SUT.Router = { "standalone/note/\($0)" }
        let sut = makeSUT(provider: provider, renderer: renderer, router: router)
        let notes = try sut.make()
        let expected = [Resource(filename: "standalone/note/any-slug", contents: "any note content")]
        
        XCTAssertEqual(notes, expected)
    }
    
    private func makeSUT(provider: SUT.Provider, renderer: SUT.Renderer, router: @escaping SUT.Router) -> SUT {
        SUT(provider: provider, renderer: renderer, router: router)
    }
    
    struct ProviderStub: SUT.Provider {
        let notes: [Note]
        func get() throws -> [Note] {notes}
    }
    
    struct Renderer: SUT.Renderer {
        let result: String
        func render(_ note: Note) -> String {result}
    }
    
    func anyNote() -> Note {
        Note(content: "any content", slug: "any-slug")
    }
}
