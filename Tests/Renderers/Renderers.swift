// © 2025  Cristian Felipe Patiño Rojas. Created on 9/6/25.

import XCTest
import BearPublisherDomain
import BearPublisherWeb

struct IndexRenderer: IndexMaker.Renderer {
    func render(notes: [Note], tags: [Tag]) -> String {
        let notes = notes.map {
            BearPublisherWeb.NoteList.Model.init(
                id: $0.id,
                title: $0.title,
                slug: $0.slug,
                isPinned: $0.isPinned,
                isEncrypted: $0.isEncrypted,
                isEmpty: $0.isEmpty,
                subtitle: $0.subtitle,
                creationDate: $0.creationDate,
                modificationDate: $0.modificationDate
            )
        }
        
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
        let notes = list.notes.map {
            BearPublisherWeb.NoteList.Model.init(
                id: $0.id,
                title: list.title,
                slug: $0.slug,
                isPinned: $0.isPinned,
                isEncrypted: $0.isEncrypted,
                isEmpty: $0.isEmpty,
                subtitle: $0.subtitle,
                creationDate: $0.creationDate,
                modificationDate: $0.modificationDate
            )
        }
        
        return BearPublisherWeb.StandaloneNoteList(title: list.title, notes: notes).body.render()
    }
}
