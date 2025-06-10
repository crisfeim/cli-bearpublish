// © 2025  Cristian Felipe Patiño Rojas. Created on 9/6/25.


import BearDatabase
import BearDomain
import BearPublisherCLI

enum NoteMapper {
    static func map(_ note: BearDatabase.Note) -> BearDomain.Note {
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
}
