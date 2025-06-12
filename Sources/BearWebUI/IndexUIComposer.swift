// © 2025  Cristian Felipe Patiño Rojas. Created on 10/6/25.

import BearDomain

public enum IndexUIComposer {
    
    public static func make(title: String, menu: Menu, notes: [Note], tags: [Tag]) -> IndexHTML {
        return IndexHTML(
            title: title,
            menu: menu,
            tags: tags,
            notes: notes
        )
    }
}
