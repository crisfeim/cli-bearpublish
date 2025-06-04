// © 2025  Cristian Felipe Patiño Rojas. Created on 3/6/25.

import XCTest


struct Note: Equatable {
    let content: String
}

struct Tag: Equatable {
    let name: String
}

enum NoteListFilter {
    case all
    case untagged
    case tasks
    case encrypted
    case archived
    case trashed
    case backlinks
    case tags
}

struct Coordinator {
    
    protocol IndexRenderer {
        func renderIndex(notes: [Note], tags: [Tag]) throws -> String
    }
    
    protocol NoteListRenderer {
        func renderAllNotes(notes: [Note]) throws -> String
    }
    
    protocol NotesProvider {
        func get(_ filter: NoteListFilter) throws -> [Note]
    }
    
    protocol TagsProvider {
        func get() throws -> [Tag]
    }
    
    let notesProvider: NotesProvider
    let tagsProvider: TagsProvider
    let indexRenderer: IndexRenderer
    let noteListRenderer: NoteListRenderer
    
    func getIndex() throws -> Resource {
        let notes    = try notesProvider.get(.all)
        let tags     = try tagsProvider.get()
        let contents = try indexRenderer.renderIndex(notes: notes, tags: tags)
        return Resource(filename: "index.html", contents: contents)
    }
    
    func getNotes(_ filter: NoteListFilter) throws -> Resource {
        let notes    = try notesProvider.get(filter)
        let contents = try noteListRenderer.renderAllNotes(notes: notes)
        return Resource(filename: "lists/all.html", contents: contents)
    }
}


class CoreTests: XCTestCase {
    
    
    func  test_getIndex_buildsIndexResourceFromProvidersAndRenderer() throws {
        
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
        
        let notesProvider = NoteListProviderSpy(notes: [anyNote()])
        
        let rendererSpy = NoteListRendererSpy(result: "any note list rendered content")
  
        let sut = makeSUT(notesProvider: notesProvider, noteListRenderer: rendererSpy)
        let allNotes = try sut.getNotes(.all)
        let expectedResources = Resource(filename: "lists/all.html", contents: "any note list rendered content")
        
        XCTAssertEqual(allNotes, expectedResources)
        XCTAssertEqual(notesProvider.capturedFilter, .all)
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
