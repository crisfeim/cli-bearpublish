// © 2025  Cristian Felipe Patiño Rojas. Created on 13/6/25.

import BearDomain

public struct BearSiteBuilder {
    public typealias NotesProvider = () throws -> [Note]
    public typealias NoteListProvider = () throws -> [NoteList]
    public typealias TagsProvider = () throws -> [Tag]
    
    let lang: String
    let sitesTitle: String
    let indexNotesProvider: NotesProvider
    let notesProvider: NotesProvider
    let listsByCategoryProvider: NoteListProvider
    let listsByTagProvider: NoteListProvider
    let tagsProvider: TagsProvider
    
    public init(
        lang: String,
        sitesTitle: String,
        indexNotesProvider: @escaping NotesProvider,
        notesProvider:  @escaping NotesProvider,
        listsByCategoryProvider:  @escaping NoteListProvider,
        listsByTagProvider:  @escaping NoteListProvider,
        tagsProvider:  @escaping TagsProvider
    ) {
        self.lang = lang
        self.sitesTitle = sitesTitle
        self.indexNotesProvider = indexNotesProvider
        self.notesProvider = notesProvider
        self.listsByCategoryProvider = listsByCategoryProvider
        self.listsByTagProvider = listsByTagProvider
        self.tagsProvider = tagsProvider
    }
    
    public func execute() throws -> BearSite {
        let indexNotes = try indexNotesProvider()
        let notes = try notesProvider()
        let tags = try tagsProvider()
        let listsByCategory = try listsByCategoryProvider()
        let listsByTag = try listsByTagProvider()
        return BearSite(
            lang: lang,
            title: sitesTitle,
            indexNotes: indexNotes,
            allNotes: notes,
            tags: tags,
            listsByCategory: listsByCategory,
            listsByTag: listsByTag,
        )
    }
}
