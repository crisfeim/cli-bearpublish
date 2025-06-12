// © 2025  Cristian Felipe Patiño Rojas. Created on 9/6/25.

import XCTest
import BearDomain
import BearWebUI

public struct IndexRenderer: IndexMaker.Renderer {
    public init() {}
    
    public func render(title: String, notes: [NoteList], tags: [Tag]) -> IndexHTML {
        IndexUIComposer.make(
            title: title,
            menu: menu(from: notes)!,
            notes: notes.first(where: { $0.title == "All" })?.notes ?? [],
            tags: tags
        )
    }
    
    public func render(title: String, notes: [NoteList], tags: [Tag]) -> String {
        render(title: title, notes: notes, tags: tags).render()
    }

    
    private func menu(from lists: [NoteList]) -> Menu? {
        guard let mainNoteList = lists.filter({ $0.title == "All" }).first else {
            return nil
        }
        let childLists = lists.filter({ $0.title != "All" }).map {
            Menu(
                name: $0.title,
                fullPath: $0.slug,
                notesCount: $0.notes.count,
                children: []
            )
        }
        
        return Menu(
            name: "All",
            fullPath: "all",
            notesCount: mainNoteList.notes.count,
            children: childLists
        )
    }
}

struct NoteRenderer: NotesMaker.Renderer {
    func render(title: String, slug: String, content: String) -> String {
        NoteHTML(title: title, slug: slug, content: content).render()
    }
}

struct NoteListRenderer: NoteListMaker.Renderer {
    func render(_ list: NoteList) -> String {
        NoteListHTML(title: list.title, notes: list.notes).render()
    }
}
