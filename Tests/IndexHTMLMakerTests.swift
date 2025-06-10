// © 2025  Cristian Felipe Patiño Rojas. Created on 10/6/25.

import XCTest
@testable import BearWebUI
import BearDomain

class IndexUIComposerTests: XCTestCase {
    
    class IndexUIComposer {
        
        let title: String
        let lists: [NoteList]
        let tags: [Tag]
        
        init(title: String, lists: [NoteList], tags: [Tag]) {
            self.title = title
            self.lists = lists
            self.tags = tags
        }
        
        var menu: Menu {
            let mainNoteList = lists.filter { $0.title == "All" }.first!
            let childLists = lists.filter({ $0.title != "All" }).map {
                Menu(name: $0.title, fullPath: $0.slug, notesCount: $0.notes.count, children: [])
            }
            
            let mainList = Menu(name: "All", fullPath: "all", notesCount: mainNoteList.notes.count, children: childLists)
            
            return mainList
        }
        
        func make() -> IndexHTML {
            let mainNoteList = lists.filter { $0.title == "All" }.first!
            return IndexHTML(
                title: title,
                menu: menu,
                tags: tags,
                notes: mainNoteList.notes
            )
        }
    }
    
    func test() {
        
        let allNotes = [anyNote(), anyNote()]
        let lists: [NoteList] = [
            NoteList(title: "All", slug: "all", notes: allNotes),
            NoteList(title: "Archived", slug: "archived", notes: [anyNote()]),
            NoteList(title: "Trashed", slug: "trashed", notes: [anyNote()]),
        ]
        
        let tags = [anyTag()]
        let sut = IndexUIComposer(title: "title", lists: lists, tags: tags)
        
        let expectedList = Menu(name: "All", fullPath: "all", notesCount: 2, children: [
            Menu(name: "Archived", fullPath: "archived", notesCount: 1, children: []),
            Menu(name: "Trashed", fullPath: "trashed", notesCount: 1, children: [])
        ])
        
        let index = sut.make()
        
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
