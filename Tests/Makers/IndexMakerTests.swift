// © 2025  Cristian Felipe Patiño Rojas. Created on 9/6/25.

import XCTest
import BearDomain

class IndexMakerTests: XCTestCase {
    
    func test_make_deliversRenderedIndexWithProvidedNotesAndTags() throws {
        
        let provider = ProviderStub(stubNotes: [anyNoteList()], stubTags: [anyTag()])
        let renderer = RendererSpy(result: "any renderer")
        
        let sut = makeSUT(
            noteListProvider: provider,
            tagsProvider: provider,
            renderer: renderer
        )
        
        let index = try sut.make()
        
        let expectedIndex = Resource(filename: "index.html", contents: "any renderer")
        
        XCTAssertEqual(index, expectedIndex)
        XCTAssertEqual(renderer.capturedTags, [anyTag()])
        XCTAssertEqual(renderer.capturedNotes, [anyNoteList()])
    }
    
    func makeSUT(
        noteListProvider: IndexMaker.NoteListProvider,
        tagsProvider: IndexMaker.TagsProvider,
        renderer: IndexMaker.Renderer
    ) -> IndexMaker {
         IndexMaker(
            noteListProvider: noteListProvider,
            tagsProvider: tagsProvider,
            renderer: renderer
        )
    }
    
    struct ProviderStub: IndexMaker.TagsProvider, IndexMaker.NoteListProvider {
        let stubNotes: [NoteList]
        let stubTags: [Tag]
        
        func get() throws -> [NoteList] { stubNotes }
        func get() throws -> [Tag] { stubTags }
    }
    
    class RendererSpy: IndexMaker.Renderer {
        private let result: String
        private(set) var capturedNotes = [NoteList]()
        private(set) var capturedTags  = [Tag]()
        
        init(result: String) {
            self.result = result
        }
        
        func render(notes: [NoteList], tags: [Tag]) -> String {
            capturedNotes = notes
            capturedTags  = tags
            return result
        }
    }
    
    func anyNoteList() -> NoteList {
        NoteList(
            title: "any note list",
            slug: "any-slug",
            notes: [anyNote()]
        )
    }
    
    func anyNote() -> Note {
        Note(
            id: 0,
            title: "any note",
            slug: "any-slug",
            isPinned: false,
            isEncrypted: false,
            isEmpty: false,
            subtitle: "any subtitle",
            creationDate: nil,
            modificationDate: nil,
            content: "any content"
        )
    }
    
    func anyTag() -> Tag {
        Tag(name: "any tag", fullPath: "any-tag", notesCount: 0, children: [], isPinned: false)
    }
}
