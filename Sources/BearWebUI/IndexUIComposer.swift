// © 2025  Cristian Felipe Patiño Rojas. Created on 10/6/25.

import BearDomain

public enum IndexUIComposer {
    
    public static func make(title: String, lists: [NoteList], tags: [Tag]) -> IndexHTML {
        let mainNoteList = lists.filter { $0.title == "All" }.first
        return IndexHTML(
            title: title,
            menu: menu(from: lists),
            tags: tags,
            notes: mainNoteList?.notes ?? []
        )
    }
    
    private static func menu(from lists: [NoteList]) -> Menu? {
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
