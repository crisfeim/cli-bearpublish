// © 2025  Cristian Felipe Patiño Rojas. Created on 9/6/25.

import XCTest

struct TaggedNoteListMaker {
    protocol Provider {
        func get() throws -> [TagNoteList]
    }
    
    let provider: Provider
    let renderer: NoteListRenderer
    
    func make() throws -> [Resource] {
        try provider.get().map {
            Resource(
                filename: "standalone/tag/\($0.tag)",
                contents: renderer.render($0.notes)
            )
        }
    }
}
class TaggedNoteListMakerTests: XCTestCase {
    
    typealias SUT = TaggedNoteListMaker
    func test_make_() throws {
        
        let provider = ProviderStub(stub: [TagNoteList(tag: "any-tag", notes: [anyNote()])])
        let renderer = NoteListRendererSpy(result: "any rendered content")
        let sut = makeSUT(provider: provider, renderer: renderer)
        let resources = try sut.make()
        let expected = [Resource(filename: "standalone/tag/any-tag", contents: "any rendered content")]
        
        XCTAssertEqual(resources, expected)
        XCTAssertEqual(renderer.capturedNotes, [anyNote()])
    }
    
    
    func makeSUT(provider: SUT.Provider, renderer: NoteListRenderer) -> SUT {
        SUT(provider: provider, renderer: renderer)
    }
    
    
    struct ProviderStub: SUT.Provider {
        let stub: [TagNoteList]
        func get() throws -> [TagNoteList] { stub }
    }
    
    class NoteListRendererSpy: NoteListRenderer {
        
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
