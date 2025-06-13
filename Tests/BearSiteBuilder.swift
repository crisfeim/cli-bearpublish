// © 2025  Cristian Felipe Patiño Rojas. Created on 13/6/25.

import BearDomain

struct BearSiteBuilder {
    typealias NotesProvider = () throws -> [Note]
    typealias NoteListProvider = () throws -> [NoteList]
    typealias TagsProvider = () throws -> [Tag]
    
    let sitesTitle: String
    let notesProvider: NotesProvider
    let listsByCategoryProvider: NoteListProvider
    let listsByTagProvider: NoteListProvider
    let tagsProvider: TagsProvider
    func execute() throws -> BearSite {
        let notes = try notesProvider()
        let tags = try tagsProvider()
        let listsByCategory = try listsByCategoryProvider()
        let listsByTag = try listsByTagProvider()
        return BearSite(
            title: sitesTitle,
            notes: notes,
            tags: tags,
            listsByCategory: listsByCategory,
            listsByTag: listsByTag,
        )
    }
}
