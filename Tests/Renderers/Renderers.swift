// © 2025  Cristian Felipe Patiño Rojas. Created on 9/6/25.

import XCTest
import BearPublisherDomain
import BearPublisherWeb

struct IndexRenderer: IndexMaker.Renderer {
    func render(notes: [Note], tags: [Tag]) -> String {

        let tags = tags.map {
            BearPublisherWeb.Menu.Model.init(
                name: $0.name,
                fullPath: $0.fullPath,
                count: $0.notesCount,
                children: [], // @todo
                isPinned: $0.isPinned,
                isSelected: false,
            )
        }
        
        return BaseLayout(title: "Home", tags: tags, notes: notes).body.render()
    }
}

struct NoteDetailRenderer: NoteDetailMaker.Renderer {
    func render(_ note: Note) -> String {
        return StandaloneNote(title: note.title, slug: note.slug, content: note.content).body.render()
    }
}

struct NoteListRenderer: NoteListMaker.Renderer {
    func render(_ list: BearPublisherDomain.NoteList) -> String {
        
        return BearPublisherWeb.StandaloneNoteList(title: list.title, notes: list.notes).body.render()
    }
}
