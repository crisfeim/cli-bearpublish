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
                Menu(title: $0.title, children: [])
            }
            
            let mainList = Menu(title: mainNoteList.title, children: childLists)
            
            return mainList
        }
        
        func make() -> IndexHTML {
            IndexHTML(title: title, menu: menu, tags: tags, notes: [])
        }
    }
    
    func test() {
        
        let lists: [NoteList] = [
            NoteList(title: "All", slug: "all", notes: [anyNote()]),
            NoteList(title: "Archived", slug: "archived", notes: [anyNote()]),
            NoteList(title: "Trashed", slug: "trashed", notes: [anyNote()]),
        ]
        
        let tags = [anyTag()]
        let sut = IndexUIComposer(title: "title", lists: lists, tags: tags)
        
        let expectedList = Menu(title: "All", children: [
            Menu(title: "Archived", children: []),
            Menu(title: "Trashed", children: [])
        ])
        
        let index = sut.make()
        
        XCTAssertEqual(index.menu, expectedList)
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
