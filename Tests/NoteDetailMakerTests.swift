// © 2025  Cristian Felipe Patiño Rojas. Created on 9/6/25.

import XCTest
import BearPublisherCLI

struct NoteDetailMaker {
    protocol Provider {
        func get() throws -> [Note]
    }
    
    protocol Renderer {
        func render(_ note: Note) -> String
    }
    
    let provider: Provider
    let renderer: Renderer
    
    func make() throws -> [Resource] {
        try provider.get().map {
            Resource(
                filename: "standalone/note/\($0.slug)",
                contents: renderer.render($0)
            )
        }
    }
}

class NoteDetailMakerTests: XCTestCase {
    typealias SUT = NoteDetailMaker
    func test_make_deliversRenderedNoteDetails() throws {
        let provider = ProviderStub(notes: [anyNote()])
        let renderer = Renderer(result: "any note content")
        let sut = makeSUT(provider: provider, renderer: renderer)
        let notes = try sut.make()
        let expected = [Resource(filename: "standalone/note/any-slug", contents: "any note content")]
        
        XCTAssertEqual(notes, expected)
    }
    
    private func makeSUT(provider: SUT.Provider, renderer: SUT.Renderer) -> SUT {
        SUT(provider: provider, renderer: renderer)
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
