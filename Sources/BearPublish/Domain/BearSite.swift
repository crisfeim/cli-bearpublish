// © 2025  Cristian Felipe Patiño Rojas. Created on 13/6/25.

import BearDomain

public struct BearSite {
    public let title: String
    public let indexNotes: [Note]
    public let allNotes: [Note]
    public let tags: [Tag]
    public let listsByCategory: [NoteList]
    public let listsByTag: [NoteList]
    
    public init(title: String, indexNotes: [Note], allNotes: [Note], tags: [Tag], listsByCategory: [NoteList], listsByTag: [NoteList]) {
        self.title = title
        self.indexNotes = indexNotes
        self.allNotes = allNotes
        self.tags = tags
        self.listsByCategory = listsByCategory
        self.listsByTag = listsByTag
    }
}
