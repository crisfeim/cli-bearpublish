// © 2025  Cristian Felipe Patiño Rojas. Created on 10/6/25.

import XCTest
import BearWebUI
import BearDomain

class IndexUIComposerTests: XCTestCase {
    
    struct List: Equatable {
        let title: String
        let children: [Self]
    }
    
    class IndexUIComposer {
        
        let lists: [BearDomain.NoteList]
        let tags: [Tag]
        
        init(lists: [BearDomain.NoteList], tags: [Tag]) {
            self.lists = lists
            self.tags = tags
        }
     
        var mainList: List {
            let mainNoteList = lists.filter { $0.title == "All" }.first!
            let childLists = lists.filter({ $0.title != "All" }).map {
                List(title: $0.title, children: [])
            }
            
            let mainList = List(title: mainNoteList.title, children: childLists)
            
            return mainList
        }
    }
    
    func test() {
        
        let lists: [BearDomain.NoteList] = [
            NoteList(title: "All", slug: "all", notes: [anyNote()]),
            NoteList(title: "Archived", slug: "archived", notes: [anyNote()]),
            NoteList(title: "Trashed", slug: "trashed", notes: [anyNote()]),
        ]
        
        let tags = [anyTag()]
        let sut = IndexUIComposer(lists: lists, tags: tags)
        
        let expectedList = List(title: "All", children: [
                List(title: "Archived", children: []),
                List(title: "Trashed", children: [])
            ])
        
        
        XCTAssertEqual(sut.mainList, expectedList)
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
