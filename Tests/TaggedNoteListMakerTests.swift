// © 2025  Cristian Felipe Patiño Rojas. Created on 9/6/25.

import XCTest

struct TaggedNoteListMaker {
    let provider: TaggedNotesProvider
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
    
    func test_make_() throws {
    
        struct NotesByTagListProvider: TaggedNotesProvider {
            let result: [TagNoteList]
            func get() throws -> [TagNoteList] {
                result
            }
        }
       
        let provider = NotesByTagListProvider(result: [TagNoteList(tag: "any-tag", notes: [anyNote()])])
        let renderer = NoteListRendererSpy(result: "any rendered content")
        let sut = makeSUT(provider: provider, renderer: renderer)
        let resources = try sut.make()
        let expected = [Resource(filename: "standalone/tag/any-tag", contents: "any rendered content")]
        
        XCTAssertEqual(resources, expected)
        XCTAssertEqual(renderer.capturedNotes, [anyNote()])
    }
    
    
    func makeSUT(provider: TaggedNotesProvider, renderer: NoteListRenderer) -> TaggedNoteListMaker {
        TaggedNoteListMaker(provider: provider, renderer: renderer)
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
