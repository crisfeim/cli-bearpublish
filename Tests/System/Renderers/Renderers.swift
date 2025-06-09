// © 2025  Cristian Felipe Patiño Rojas. Created on 9/6/25.

import XCTest
import BearDomain
import BearWebUI

struct IndexRenderer: IndexMaker.Renderer {
    func render(notes: [Note], tags: [Tag]) -> String {
        IndexHTML(title: "Home", tags: tags, notes: notes).render()
    }
}

struct NoteDetailRenderer: NoteDetailMaker.Renderer {
    func render(_ note: Note) -> String {
       NoteDetailHTML(title: note.title, slug: note.slug, content: note.content).render()
    }
}

struct NoteListRenderer: NoteListMaker.Renderer {
    func render(_ list: BearDomain.NoteList) -> String {
        NoteListHTML(title: list.title, notes: list.notes).render()
    }
}
