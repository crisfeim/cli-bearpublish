// © 2025  Cristian Felipe Patiño Rojas. Created on 9/6/25.


import BearDatabase
import BearDomain
import BearWebUI

enum NoteMapper {
    static func map(_ note: DBNote) -> Note {
        Note(
            id: note.id,
            title: note.title ?? "New note",
            slug: slugify(note.title ?? "New note"),
            isPinned: note.isPinned,
            isEncrypted: note.isEncrypted,
            isEmpty: note.content?.isEmpty ?? true,
            subtitle: note.subtitle ?? "",
            creationDate: note.creationDate,
            modificationDate: note.modificationDate,
            content: note.content ?? ""
        )
    }
    
    static func map(_ note: Note) -> NoteViewModel {
        NoteViewModel(
            id: note.id,
            title: note.title,
            slug: note.slug,
            isPinned: note.isPinned,
            isEncrypted: note.isEncrypted,
            isEmpty: note.isEmpty,
            subtitle: note.subtitle,
            creationDate: note.creationDate,
            modificationDate: note.modificationDate,
            content: note.content
        )
    }
}
