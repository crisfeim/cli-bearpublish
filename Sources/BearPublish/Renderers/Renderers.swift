// © 2025  Cristian Felipe Patiño Rojas. Created on 9/6/25.

import XCTest
import BearDomain
import BearWebUI

struct IndexRenderer: IndexMaker.Renderer {
    func render(notes: [NoteList], tags: [Tag]) -> String {
        IndexUIComposer.make(title: "Home", lists: notes, tags: tags).render()
    }
}

struct NoteRenderer: NotesMaker.Renderer {
    func render(title: String, slug: String, content: String) -> String {
        NoteDetailHTML(title: title, slug: slug, content: content).render()
    }
}

struct NoteListRenderer: NoteListMaker.Renderer {
    func render(_ list: NoteList) -> String {
        NoteListHTML(title: list.title, notes: list.notes).render()
    }
}
