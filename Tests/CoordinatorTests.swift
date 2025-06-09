// © 2025  Cristian Felipe Patiño Rojas. Created on 3/6/25.

import XCTest


class CoordinatorTests: XCTestCase {
    func test_getNotesByFilter_buildsAllNoteListResourceFromNoteProviderAndRenderer() throws {
        
        let notesProvider = NoteListProviderSpy(notes: [anyNote()])
        let rendererSpy = NoteListRendererSpy(result: "any note list rendered content")
        let sut = makeSUT(notesProvider: notesProvider, noteListRenderer: rendererSpy)
        
        let expectedFilter = NoteListFilter.archived
        let allNotes = try sut.getNotes(expectedFilter)
        
        let expectedResources = Resource(filename: "standalone/list/\(expectedFilter.rawValue).html", contents: "any note list rendered content")
        XCTAssertEqual(allNotes, expectedResources)
        XCTAssertEqual(notesProvider.capturedFilter, expectedFilter)
    }
    
    func test_getTaggedNotes_buildTaggedNoteListsResourcesFromTaggedNotesProviderAndNoteListRenderer() throws {
    
        struct NotesByTagListProvider: TaggedNotesProvider {
            let result: [TagNoteList]
            func get() throws -> [TagNoteList] {
                result
            }
        }
       
        let provider = NotesByTagListProvider(result: [TagNoteList(tag: "any-tag", notes: [anyNote()])])
        let noteListRenderer = NoteListRendererSpy(result: "any rendered content")
        let sut = makeSUT(taggedNotesProvider: provider, noteListRenderer: noteListRenderer)
        let noteListByTag = try sut.getTaggedNotes()
        let expected = [Resource(filename: "standalone/tag/any-tag", contents: "any rendered content")]
        
        XCTAssertEqual(noteListByTag, expected)
        XCTAssertEqual(noteListRenderer.capturedNotes, [anyNote()])
    }
}

// MARK: - Helpers
private extension CoordinatorTests {
    
    func makeSUT(
        notesProvider: NotesProvider = NotesProviderDummy(),
        taggedNotesProvider:TaggedNotesProvider = TaggedNotesProviderDummy(),
        tagsProvider: TagsProvider = TagsProviderDummy(),
        indexRenderer: IndexRenderer = IndexRendererDummy(),
        noteListRenderer: NoteListRenderer = NoteListRendererDummy(),
        noteDetailRenderer:NoteDetailRenderer = NoteDetailRendererDummy()
    ) -> Coordinator {
        Coordinator(
            notesProvider: notesProvider,
            taggedNotesProvider: taggedNotesProvider,
            tagsProvider: tagsProvider,
            indexRenderer: indexRenderer,
            noteListRenderer: noteListRenderer,
            noteDetailRenderer: noteDetailRenderer
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
        
        func render(_ notes: [Note]) throws -> String {
            capturedNotes = notes
            return result
        }
    }
    
    struct TagsProviderDummy: TagsProvider {
        func get() throws -> [Tag] {[]}
    }
    
    struct IndexRendererDummy: IndexRenderer {
        func render(notes: [Note], tags: [Tag]) -> String {""}
    }
    
    struct NoteListRendererDummy: NoteListRenderer {
        func render(_ notes: [Note]) throws -> String {""}
    }
    
    struct NotesProviderDummy:NotesProvider {
        func get(_ filter: NoteListFilter) throws -> [Note] {[]}
    }
    
    struct TaggedNotesProviderDummy: TaggedNotesProvider {
        func get() throws -> [TagNoteList] {[]}
    }
    
    struct NoteDetailRendererDummy: NoteDetailRenderer {
        func render(_ note: Note) -> String {""}
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
