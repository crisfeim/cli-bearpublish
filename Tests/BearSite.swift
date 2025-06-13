// © 2025  Cristian Felipe Patiño Rojas. Created on 13/6/25.

import BearDomain

struct BearSite {
    let title: String
    let notes: [Note]
    let tags: [Tag]
    let listsByCategory: [NoteList]
    let listsByTag: [NoteList]
}
