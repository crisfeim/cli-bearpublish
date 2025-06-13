// © 2025  Cristian Felipe Patiño Rojas. Created on 13/6/25.

import BearDomain

public struct BearSiteBuilder {
    public typealias NotesProvider = () throws -> [Note]
    public typealias NoteListProvider = () throws -> [NoteList]
    public typealias TagsProvider = () throws -> [Tag]
    
    let sitesTitle: String
    let notesProvider: NotesProvider
    let listsByCategoryProvider: NoteListProvider
    let listsByTagProvider: NoteListProvider
    let tagsProvider: TagsProvider
    
    public init(
        sitesTitle: String,
        notesProvider:  @escaping NotesProvider,
        listsByCategoryProvider:  @escaping NoteListProvider,
        listsByTagProvider:  @escaping NoteListProvider,
        tagsProvider:  @escaping TagsProvider
    ) {
        self.sitesTitle = sitesTitle
        self.notesProvider = notesProvider
        self.listsByCategoryProvider = listsByCategoryProvider
        self.listsByTagProvider = listsByTagProvider
        self.tagsProvider = tagsProvider
    }
    
    public func execute() throws -> BearSite {
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
