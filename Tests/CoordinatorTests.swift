// © 2025  Cristian Felipe Patiño Rojas. Created on 3/6/25.

import XCTest


class CoordinatorTests: XCTestCase {
    
    func test_getIndex_buildsIndexResourceFromProvidersAndRenderer() throws {
        
        let providerSpy = ProviderSpy(notes: [anyNote()], tags: [anyTag()])
        let indexRenderer = IndexRendererSpy(result: "any renderer")
        let sut = makeSUT(notesProvider: providerSpy, tagsProvider: providerSpy,  indexRenderer: indexRenderer)
        
        let index = try sut.getIndex()
        
        let expectedIndex = Resource(filename: "index.html", contents: "any renderer")
        let expectedNoteListFilter = NoteListFilter.all
        XCTAssertEqual(index, expectedIndex)
        XCTAssertEqual(indexRenderer.capturedTags, [anyTag()])
        XCTAssertEqual(indexRenderer.capturedNotes, [anyNote()])
        XCTAssertEqual(providerSpy.capturedFilter, expectedNoteListFilter)
    }
    
    func test_getNotesByFilter_buildsAllNoteListResourceFromNoteProviderAndRenderer() throws {
        
       
        let notesProvider = NoteListProviderSpy(notes: [anyNote()])
        let rendererSpy = NoteListRendererSpy(result: "any note list rendered content")
        let sut = makeSUT(notesProvider: notesProvider, noteListRenderer: rendererSpy)
        
        let expectedFilter = NoteListFilter.archived
        let allNotes = try sut.getNotes(expectedFilter)
        
        let expectedResources = Resource(filename: "lists/\(expectedFilter.rawValue).html", contents: "any note list rendered content")
        XCTAssertEqual(allNotes, expectedResources)
        XCTAssertEqual(notesProvider.capturedFilter, expectedFilter)
    }
    
    func makeSUT(
        notesProvider: Coordinator.NotesProvider,
        tagsProvider: Coordinator.TagsProvider = TagsProviderDummy(),
        indexRenderer: Coordinator.IndexRenderer = IndexRendererDummy(),
        noteListRenderer: Coordinator.NoteListRenderer = NoteListRendererDummy()
    ) -> Coordinator {
        Coordinator(
            notesProvider: notesProvider,
            tagsProvider: tagsProvider,
            indexRenderer: indexRenderer,
            noteListRenderer: noteListRenderer
        )
    }
    
    final class ProviderSpy: Coordinator.TagsProvider, Coordinator.NotesProvider {
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
    
    class IndexRendererSpy: Coordinator.IndexRenderer {
        private let result: String
        private(set) var capturedNotes = [Note]()
        private(set) var capturedTags  = [Tag]()
        
        init(result: String) {
            self.result = result
        }
        
        func renderIndex(notes: [Note], tags: [Tag]) throws -> String {
            capturedNotes = notes
            capturedTags  = tags
            return result
        }
    }
    
    final class NoteListProviderSpy: Coordinator.NotesProvider {
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
    
    
    class NoteListRendererSpy: Coordinator.NoteListRenderer {
        
        private let result: String
        private(set) var capturedNotes = [Note]()
        init(result: String) {
            self.result = result
        }
        
        func renderAllNotes(notes: [Note]) throws -> String {
            capturedNotes = notes
            return result
        }
    }
    
    struct TagsProviderDummy: Coordinator.TagsProvider {
        func get() throws -> [Tag] {[]}
    }
    
    struct IndexRendererDummy: Coordinator.IndexRenderer {
        func renderIndex(notes: [Note], tags: [Tag]) throws -> String {""}
    }
    
    struct NoteListRendererDummy: Coordinator.NoteListRenderer {
        func renderAllNotes(notes: [Note]) throws -> String {""}
    }
    
    func anyNote() -> Note {
        Note(content: "any content")
    }
    
    func anyTag() -> Tag {
        Tag(name: "any tag")
    }
    
}
