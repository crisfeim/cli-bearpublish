// © 2025  Cristian Felipe Patiño Rojas. Created on 13/6/25.

import BearDomain
import BearPublish
import Foundation

struct BearPublisher {
    
    let execute: () async throws -> Void
    
    init(
        outputURL: URL,
        siteTitle: String,
        notesProvider: @escaping () throws -> [Note],
        categoryListProvider: @escaping () throws -> [NoteList],
        tagListProvider: @escaping () throws -> [NoteList],
        tagProvider: @escaping () throws -> [Tag],
        indexRenderer: BearSiteRenderer.IndexRenderer,
        noteRenderer: BearSiteRenderer.NoteRenderer,
        listByCategoryRenderer: BearSiteRenderer.ListRenderer,
        listByTagRenderer: BearSiteRenderer.ListRenderer,
        assetsProvider: @escaping () -> [Resource]
    ) throws {
        let builder = BearSiteBuilder(
            sitesTitle: siteTitle,
            notesProvider: notesProvider,
            listsByCategoryProvider: categoryListProvider,
            listsByTagProvider: tagListProvider,
            tagsProvider: tagProvider
        )
        
        let renderer = BearSiteRenderer(
            site: try builder.execute(),
            indexRenderer: indexRenderer,
            noteRenderer: noteRenderer,
            listsByCategoryRenderer: listByCategoryRenderer,
            listsByTagRenderer: listByTagRenderer,
            assetsProvider: assetsProvider
        )
        
        execute = BearSiteGenerator(site: renderer.execute(), outputURL: outputURL).execute
    }
}
