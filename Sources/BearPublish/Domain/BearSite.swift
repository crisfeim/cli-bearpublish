// © 2025  Cristian Felipe Patiño Rojas. Created on 13/6/25.

import BearDomain

public struct BearSite {
    public let title: String
    public let notes: [Note]
    public let tags: [Tag]
    public let listsByCategory: [NoteList]
    public let listsByTag: [NoteList]
    
    public init(title: String, notes: [Note], tags: [Tag], listsByCategory: [NoteList], listsByTag: [NoteList]) {
        self.title = title
        self.notes = notes
        self.tags = tags
        self.listsByCategory = listsByCategory
        self.listsByTag = listsByTag
    }
}
