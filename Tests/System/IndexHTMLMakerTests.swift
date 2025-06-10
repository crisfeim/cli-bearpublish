// © 2025  Cristian Felipe Patiño Rojas. Created on 10/6/25.

import XCTest
@testable import BearWebUI
import BearDomain

class IndexUIComposerTests: XCTestCase {
    
    
    
    func test() {
        let allNotes = [anyNote(), anyNote()]
        let lists: [NoteList] = [
            NoteList(title: "All", slug: "all", notes: allNotes),
            NoteList(title: "Archived", slug: "archived", notes: [anyNote()]),
            NoteList(title: "Trashed", slug: "trashed", notes: [anyNote()]),
        ]
        
        let tags = [anyTag()]

        let expectedList = Menu(name: "All", fullPath: "all", notesCount: 2, children: [
            Menu(name: "Archived", fullPath: "archived", notesCount: 1, children: []),
            Menu(name: "Trashed", fullPath: "trashed", notesCount: 1, children: [])
        ])
        
        let index = IndexUIComposer.make(title: "title", lists: lists, tags: tags)
        
        XCTAssertEqual(index.menu, expectedList)
        XCTAssertEqual(index.title, "title")
        XCTAssertEqual(index.tags, tags)
        XCTAssertEqual(index.notes, allNotes)
    }
    
    
    func anyNote() -> Note {
        Note(
            id: 0,
            title: "any note",
            slug: "any-note",
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
        Tag(
            name: "any tag",
            fullPath: "any-full-path",
            notesCount: 0,
            children: [],
            isPinned: false
        )
    }
}
