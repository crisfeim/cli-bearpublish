import XCTest
@testable import BearWebUI
import BearDomain

enum IndexUIComposer {
        static func make(title: String, lists: [NoteList], tags: [Tag]) -> IndexHTML {
            var menu: Menu {
                let mainNoteList = lists.filter { $0.title == "All" }.first!
                let childLists = lists.filter({ $0.title != "All" }).map {
                    Menu(name: $0.title, fullPath: $0.slug, notesCount: $0.notes.count, children: [])
                }
                
                let mainList = Menu(name: "All", fullPath: "all", notesCount: mainNoteList.notes.count, children: childLists)
                
                return mainList
            }
            
            let mainNoteList = lists.filter { $0.title == "All" }.first!
            return IndexHTML(
                title: title,
                menu: menu,
                tags: tags,
                notes: mainNoteList.notes
            )
        }
    }