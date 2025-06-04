// © 2025  Cristian Felipe Patiño Rojas. Created on 3/6/25.

import XCTest


struct Note: Equatable {
    let content: String
}

struct Tag: Equatable {
    let name: String
}

enum NotesFilter {
    case all
    case untagged
    case tasks
    case encrypted
    case archived
    case trashed
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
        
        class RendererSpy: Coordinator.IndexRenderer {
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
        
        struct NoteListRendererDummy: Coordinator.NoteListRenderer {
            func renderAllNotes(notes: [Note]) throws -> String {""}
        }
    
        let providerStub = ProviderStub(notes: [anyNote()], tags: [anyTag()])
        let renderer = RendererSpy(result: "any renderer")
        let sut = Coordinator(notesProvider: providerStub, tagsProvider: providerStub, indexRenderer: renderer, noteListRenderer: NoteListRendererDummy())
        let index = try sut.getIndex()
        let expectedIndex = Resource(filename: "index.html", contents: "any renderer")
        
        XCTAssertEqual(index, expectedIndex)
        XCTAssertEqual(renderer.capturedTags, [anyTag()])
        XCTAssertEqual(renderer.capturedNotes, [anyNote()])
    }
    
    func test_getAllNotes_buildsAllNoteListResourceFromNoteProviderAndRenderer() throws {
       
        struct NotesProviderStub: Coordinator.NotesProvider {
            let notes: [Note]
            func get() throws -> [Note] {
                notes
            }
        }
        
        struct TagsProviderDummy: Coordinator.TagsProvider {
            func get() throws -> [Tag] {[]}
        }
        
        struct RendererDummy: Coordinator.IndexRenderer, Coordinator.NoteListRenderer {
            func renderIndex(notes: [Note], tags: [Tag]) throws -> String {""}
            func renderAllNotes(notes: [Note]) throws -> String {"any rendered content"}
        }
        
        let notesProvider = NotesProviderStub(notes: [anyNote()])
        let tagsProvider = TagsProviderDummy()
        let renderer = RendererDummy()
        let sut = Coordinator(notesProvider: notesProvider, tagsProvider: tagsProvider, indexRenderer: renderer, noteListRenderer: renderer)
        let allNotes = try sut.getAllNotes()
        let expectedResources = Resource(filename: "lists/all.html", contents: "any rendered content")
        
        XCTAssertEqual(allNotes, expectedResources)
    }
    
    func anyNote() -> Note {
        Note(content: "any content")
    }
    
    func anyTag() -> Tag {
        Tag(name: "any tag")
    }
    
}
