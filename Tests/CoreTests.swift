// © 2025  Cristian Felipe Patiño Rojas. Created on 3/6/25.

import XCTest


struct Note: Equatable {
    let content: String
}

struct Tag: Equatable {
    let name: String
}

struct Coordinator {
    
    protocol Renderer {
        func renderIndex(notes: [Note], tags: [Tag]) throws -> String
    }
    
    protocol NotesProvider {
        func get() throws -> [Note]
    }
    
    protocol TagsProvider {
        func get() throws -> [Tag]
    }
    
    let notesProvider: NotesProvider
    let tagsProvider: TagsProvider
    let renderer: Renderer
    
    func getIndex() throws -> Resource {
        let notes    = try notesProvider.get()
        let tags     = try tagsProvider.get()
        let contents = try renderer.renderIndex(notes: notes, tags: tags)
        return Resource(filename: "index.html", contents: contents)
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
        
        class RendererSpy: Coordinator.Renderer {
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
        let renderer = RendererSpy(result: "any renderer")
        let sut = Coordinator(notesProvider: providerStub, tagsProvider: providerStub, renderer: renderer)
        let index = try sut.getIndex()
        let expectedIndex = Resource(filename: "index.html", contents: "any renderer")
        
        XCTAssertEqual(index, expectedIndex)
        XCTAssertEqual(renderer.capturedTags, [anyTag()])
        XCTAssertEqual(renderer.capturedNotes, [anyNote()])
    }
    
    func anyNote() -> Note {
        Note(content: "any content")
    }
    
    func anyTag() -> Tag {
        Tag(name: "any tag")
    }
    
}
