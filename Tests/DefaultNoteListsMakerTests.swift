// © 2025  Cristian Felipe Patiño Rojas. Created on 3/6/25.

import XCTest

struct DefaultNoteListsMaker {
    let provider: NotesProvider
    let renderer: NoteListRenderer
    
    func make(_ filter: NoteListFilter) throws -> Resource {
        let notes = try provider.get(filter)
        let contents = renderer.render(notes)
        return Resource(filename: "standalone/list/\(filter.rawValue).html", contents: contents)
    }
}

class DefaultNoteListsMakerTests: XCTestCase {

    func test_make() throws {
        let provider = NoteListProviderSpy(notes: [anyNote()])
        let renderer = NoteListRendererSpy(result: "any note list rendered content")
        let sut = makeSUT(provider: provider, renderer: renderer)
        
        let expectedFilter = NoteListFilter.archived
        let resources = try sut.make(expectedFilter)
        
        let expectedResources = Resource(filename: "standalone/list/\(expectedFilter.rawValue).html", contents: "any note list rendered content")
        XCTAssertEqual(resources, expectedResources)
        XCTAssertEqual(provider.capturedFilter, expectedFilter)
    }
}

// MARK: - Helpers
private extension DefaultNoteListsMakerTests {
    
    func makeSUT(provider: NotesProvider, renderer: NoteListRenderer) -> DefaultNoteListsMaker {
        DefaultNoteListsMaker(
            provider: provider,
            renderer: renderer
        )
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
    
    struct NoteDetailRendererStub: NoteDetailRenderer {
        let result: String
        func render(_ note: Note) -> String {result}
    }
    
    
    func anyNote() -> Note {
        Note(content: "any content", slug: "any-slug")
    }
    
    func anyTag() -> Tag {
        Tag(name: "any tag")
    }
    
}
