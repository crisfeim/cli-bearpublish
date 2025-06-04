// © 2025  Cristian Felipe Patiño Rojas. Created on 3/6/25.

import XCTest


struct Note: Equatable {
    let content: String
}

struct Tag: Equatable {
    let name: String
}

struct Coordinator {
    
    protocol IndexRenderer {
        func renderIndex(notes: [Note], tags: [Tag]) throws -> String
    }
    
    protocol NoteListRenderer {
        func renderAllNotes(notes: [Note]) throws -> String
    }
    
    protocol NotesProvider {
        func get() throws -> [Note]
    }
    
    protocol TagsProvider {
        func get() throws -> [Tag]
    }
    
    let notesProvider: NotesProvider
    let tagsProvider: TagsProvider
    let indexRenderer: IndexRenderer
    let noteListRenderer: NoteListRenderer
    
    func getIndex() throws -> Resource {
        let notes    = try notesProvider.get()
        let tags     = try tagsProvider.get()
        let contents = try indexRenderer.renderIndex(notes: notes, tags: tags)
        return Resource(filename: "index.html", contents: contents)
    }
    
    func getAllNotes() throws -> Resource {
        let notes = try notesProvider.get()
        let contents = try noteListRenderer.renderAllNotes(notes: notes)
        return Resource(filename: "lists/all.html", contents: contents)
    }
}


class CoreTests: XCTestCase {
    
    
    func  test_getIndex_buildsIndexResourceFromProvidersAndRenderer() throws {
        
        struct ProviderStub: Coordinator.TagsProvider, Coordinator.NotesProvider {
            let notes: [Note]
            let tags: [Tag]
            
            func get() throws -> [Note] {
                notes
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

        let providerStub = ProviderStub(notes: [anyNote()], tags: [anyTag()])
        let indexRenderer = IndexRendererSpy(result: "any renderer")
        let sut = makeSUT(notesProvider: providerStub, tagsProvider: providerStub,  indexRenderer: indexRenderer)
        let index = try sut.getIndex()
        let expectedIndex = Resource(filename: "index.html", contents: "any renderer")
        
        XCTAssertEqual(index, expectedIndex)
        XCTAssertEqual(indexRenderer.capturedTags, [anyTag()])
        XCTAssertEqual(indexRenderer.capturedNotes, [anyNote()])
    }
    
    func test_getAllNotes_buildsAllNoteListResourceFromNoteProviderAndRenderer() throws {
        
        struct NotesProviderStub: Coordinator.NotesProvider {
            let notes: [Note]
            func get() throws -> [Note] {
                notes
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
        
        let notesProvider = NotesProviderStub(notes: [anyNote()])
        
        let rendererSpy = NoteListRendererSpy(result: "any note list rendered content")
  
        let sut = makeSUT(notesProvider: notesProvider, noteListRenderer: rendererSpy)
        let allNotes = try sut.getAllNotes()
        let expectedResources = Resource(filename: "lists/all.html", contents: "any note list rendered content")
        
        XCTAssertEqual(allNotes, expectedResources)
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
