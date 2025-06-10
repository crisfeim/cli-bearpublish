// © 2025  Cristian Felipe Patiño Rojas. Created on 9/6/25.

import Foundation
import BearWebUI
import BearDatabase
import BearDomain

extension BearSite {
   public static func make(dbPath: String, outputURL: URL) throws -> BearSite {
        let bearDb = try BearDb(path: dbPath)
        
        let noteListProvider = DefaultNoteListProvider(bearDb: bearDb)
        let tagProvider = TagsProvider(bearDb: bearDb)
        let notesProvider = NotesProvider(bearDb: bearDb)
        
        let index = IndexMaker(
            notes: try noteListProvider.get(),
            tags: try tagProvider.get(),
            renderer: IndexRenderer()
        )
        
        let notes = NotesMaker(
            provider: notesProvider,
            renderer: NoteRenderer(),
            router: Router.note
        )
        
        let noteLists = NoteListMaker(
            lists: try noteListProvider.get(),
            renderer: NoteListRenderer(),
            router: Router.list
        )
        
        let noteListsForTags = NoteListMaker(
            lists: try TagsNoteListsProvider(bearDb: bearDb).get(),
            renderer: NoteListRenderer(),
            router: Router.tag
        )
        
        let `static` = IndexHTML.static().map(ResourceMapper.map)
        
        return BearSite(
            index: index,
            notes: notes,
            listsByCategory: noteLists,
            listsByHashtag: noteListsForTags,
            assets: `static`,
            outputURL: outputURL
        )
    }
}
