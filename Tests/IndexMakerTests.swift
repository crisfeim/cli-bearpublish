// © 2025  Cristian Felipe Patiño Rojas. Created on 9/6/25.

import XCTest
import BearPublisherCLI

class IndexMakerTests: XCTestCase {
    
    struct IndexMaker {
        let notesProvider: NotesProvider
        let tagsProvider: TagsProvider
        let renderer: IndexRenderer
        
        func make() throws -> Resource {
            let notes = try notesProvider.get(.all)
            let tags = try tagsProvider.get()
            let rendered = renderer.render(notes: notes, tags: tags)
            return Resource(filename: "index.html", contents: rendered)
        }
    }
    
    func test_make_deliversRenderedIndexWithProvidedNotesAndTags() throws {
        
        let provider = ProviderSpy(notes: [anyNote()], tags: [anyTag()])
        let renderer = IndexRendererSpy(result: "any renderer")
        
        let sut = makeSUT(notesProvider: provider, tagsProvider: provider,  renderer: renderer)
        
        let index = try sut.make()
        
        let expectedIndex = Resource(filename: "index.html", contents: "any renderer")
        
        XCTAssertEqual(index, expectedIndex)
        XCTAssertEqual(renderer.capturedTags, [anyTag()])
        XCTAssertEqual(renderer.capturedNotes, [anyNote()])
        XCTAssertEqual(provider.capturedFilter, .all)
    }
    
    func makeSUT(notesProvider: NotesProvider, tagsProvider: TagsProvider, renderer: IndexRenderer) -> IndexMaker {
         IndexMaker(
            notesProvider: notesProvider,
            tagsProvider: tagsProvider,
            renderer: renderer
        )
    }
    
    final class ProviderSpy: TagsProvider, NotesProvider {
        private let notes: [Note]
        private let tags: [Tag]
        
        private(set) var capturedFilter: NoteListFilter?
        
        init(notes: [Note], tags: [Tag]) {
            self.notes = notes
            self.tags = tags
        }
    
        func get(_ filter: NoteListFilter) throws -> [Note] {
           capturedFilter = filter
           return notes
        }
        
        func get() throws -> [Tag] {
            tags
        }
    }
    
    class IndexRendererSpy: IndexRenderer {
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
        Note(content: "any content", slug: "any-slug")
    }
    
    func anyTag() -> Tag {
        Tag(name: "any tag")
    }
}
