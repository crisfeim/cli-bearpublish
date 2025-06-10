// © 2025  Cristian Felipe Patiño Rojas. Created on 9/6/25.

import XCTest
import BearDomain

class IndexMakerTests: XCTestCase {
    
    func test_make_deliversRenderedIndexWithProvidedNotesAndTags() {
        
        let renderer = RendererSpy(result: "any renderer")
        
        let sut = IndexMaker(notes: [anyNoteList()], tags: [anyTag()], renderer: renderer)
        let index = sut()
        
        let expectedIndex = Resource(filename: "index.html", contents: "any renderer")
        
        XCTAssertEqual(index, expectedIndex)
        XCTAssertEqual(renderer.capturedTags, [anyTag()])
        XCTAssertEqual(renderer.capturedNotes, [anyNoteList()])
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
