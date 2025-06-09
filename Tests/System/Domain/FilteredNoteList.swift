// © 2025  Cristian Felipe Patiño Rojas. Created on 9/6/25.


struct FilteredNoteList: Equatable {
    let filter: String
    let slug: String
    let notes: [Note]
}