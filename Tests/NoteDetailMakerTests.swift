// © 2025  Cristian Felipe Patiño Rojas. Created on 9/6/25.

import XCTest
import BearPublisherCLI

struct NoteDetailMaker {
    let notesProvider: NotesProvider
    let renderer: NoteDetailRenderer
    
    func make() throws -> [Resource] {
        try notesProvider.get(.all).map {
            Resource(
                filename: "standalone/note/\($0.slug)",
                contents: renderer.render($0)
            )
        }
    }
}

class NoteDetailMakerTests: XCTestCase {
    func test_make_deliversRenderedNoteDetails() throws {
        let provider = NoteListProviderSpy(notes: [anyNote()])
        let renderer = NoteDetailRendererStub(result: "any note content")
        let sut = makeSUT(notesProvider: provider, renderer: renderer)
        let notes = try sut.make()
        let expected = [Resource(filename: "standalone/note/any-slug", contents: "any note content")]
        
        XCTAssertEqual(notes, expected)
    }
    
    private func makeSUT(notesProvider: NotesProvider, renderer: NoteDetailRenderer) -> NoteDetailMaker {
        NoteDetailMaker(notesProvider: notesProvider, renderer: renderer)
    }
    
    final class NoteListProviderSpy: NotesProvider {
        private let notes: [Note]
        
        private(set) var capturedFilter: NoteListFilter?
        
        init(notes: [Note]) {
            self.notes = notes
        }
    
        func get(_ filter: NoteListFilter) throws -> [Note] {
           capturedFilter = filter
           return notes
        }
    }
    
    struct NoteDetailRendererStub: NoteDetailRenderer {
        let result: String
        func render(_ note: Note) -> String {result}
    }
    
    func anyNote() -> Note {
        Note(content: "any content", slug: "any-slug")
    }
}
