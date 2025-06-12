// © 2025  Cristian Felipe Patiño Rojas. Created on 9/6/25.

import BearDomain
import BearWebUI

public struct IndexRenderer: IndexMaker.Renderer {
    public init() {}
    
    public func render(title: String, notes: [NoteList], tags: [Tag]) -> IndexHTML {
        IndexUIComposer.make(
            title: title,
            menu: menu(from: notes),
            notes: notes.first(where: { $0.title == "All" })?.notes ?? [],
            tags: tags
        )
    }
    
    public func render(title: String, notes: [NoteList], tags: [Tag]) -> String {
        render(title: title, notes: notes, tags: tags).render()
    }

    
    private func menu(from lists: [NoteList]) -> [Menu] {
        let main = lists.first(where: { $0.title == "All" })
        let trashed = lists.first(where: { $0.title == "Trashed" })
        let archived = lists.first(where: { $0.title == "Archived" })
        let tasks = lists.first(where: { $0.title == "Tasks" })
        let untagged = lists.first(where: { $0.title == "Untagged" })
        
        return [
            Menu(name: "All", fullPath: "all", notesCount: main!.notes.count, children: [
                Menu(name: "Untagged", fullPath: "untagged", notesCount: untagged!.notes.count, children: []),
                Menu(name: "Tasks", fullPath: "tasks", notesCount: tasks!.notes.count, children: [])
            ]),
            Menu(name: "Archived", fullPath: "archived", notesCount: archived!.notes.count, children: []),
            Menu(name: "Trashed", fullPath: "trashed", notesCount: trashed!.notes.count, children: [])
        ]
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
