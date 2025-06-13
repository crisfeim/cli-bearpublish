// © 2025  Cristian Felipe Patiño Rojas. Created on 13/6/25.

import BearDomain
import BearPublish

struct BearSiteRenderer {
   
    protocol IndexRenderer {
        func render(title: String, lists: [NoteList], notes: [Note], tags: [Tag]) -> Resource
    }
    
    protocol NoteRenderer {
        func render(title: String, slug: String, content: String) -> Resource
    }
    
    protocol ListRenderer {
        func render(title: String, slug: String, notes: [Note]) -> Resource
    }
    
    typealias AssetsProvider = () -> [Resource]
    
    let site: BearSite
    let indexRenderer: IndexRenderer
    let noteRenderer: NoteRenderer
    let listsByCategoryRenderer: ListRenderer
    let listsByTagRenderer: ListRenderer
    let assetsProvider: AssetsProvider
    
    func execute() -> BearRenderedSite {
        BearRenderedSite(
            index: indexRenderer.render(
                title: site.title,
                lists: site.listsByCategory,
                notes: site.notes,
                tags: site.tags
            ),
            notes: site.notes.map(renderNote),
            listsByCategory: site.listsByCategory.map(renderListByCategory),
            listsByTag: site.listsByTag.map(renderListByTag),
            assets: assetsProvider()
        )
    }
    
    private func renderNote(_ note: Note) -> Resource {
        noteRenderer.render(
            title: note.title,
            slug: note.slug,
            content: note.content
        )
    }
    
    private func renderListByCategory(_ noteList: NoteList) -> Resource {
        listsByCategoryRenderer.render(title: noteList.title, slug: noteList.slug, notes: noteList.notes)
    }
    
    private func renderListByTag(_ noteList: NoteList) -> Resource {
        listsByTagRenderer.render(title: noteList.title, slug: noteList.slug, notes: noteList.notes)
    }
}
