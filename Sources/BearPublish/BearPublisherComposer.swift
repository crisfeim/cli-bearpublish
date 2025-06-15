// © 2025  Cristian Felipe Patiño Rojas. Created on 9/6/25.

import Foundation
import BearWebUI
import BearDatabase
import BearDomain
import BearMarkdown

public enum BearPublisherComposer {
    public static func make(dbPath: String, outputURL: URL, filesFolderURL: URL, imagesFolderURL: URL, siteTitle: String) throws  -> BearPublisher {
        let bearDB = try BearDb(path: dbPath)
        let parser = BearMarkdown(
            slugify: slugify,
            imgProcessor: bearDB.imgProcessor,
            hashtagProcessor: bearDB.hashtagProcessor,
            fileBlockProcessor: bearDB.fileblockProcessor
        )
        
        return try BearPublisher(
            outputURL: outputURL,
            siteTitle: siteTitle,
            indexNotesProvider: bearDB.fetchNotes >> NoteMapper.map,
            notesProvider: bearDB.fetchAll >> NoteMapper.map,
            tagProvider: bearDB.fetchTagTree >> TagMapper.map,
            categoryListProvider: CategoryNoteListProvider(bearDb: bearDB).get,
            tagListProvider: TagsNoteListsProvider(bearDb: bearDB).get,
            indexRenderer: IndexRenderer(),
            noteRenderer: NoteRenderer(parser: parser.parse),
            listByCategoryRenderer: CategoryListRenderer(),
            listByTagRenderer: TagListRenderer(),
            filesFolderURL: filesFolderURL,
            imagesFolderURL: imagesFolderURL,
            assetsProvider: assetsProvider)
    }
}

infix operator >>
private func >><A, B>(lhs: @escaping () throws -> [A], rhs: @escaping (A) -> B) -> () throws -> [B] {
    return { try lhs().map { rhs($0) } }
}


private extension BearPublisherComposer {

    struct IndexRenderer: BearSiteRenderer.IndexRenderer {
        func render(title: String, lists: [NoteList], notes: [Note], tags: [Tag]) -> Resource {
            let html = IndexHTML(
                title: title,
                menu: menu(main: notes, from: lists),
                tags: tags.map(TagMapper.map),
                notes: notes.map(NoteMapper.map)
            )
            
            return Resource(filename: "index.html", contents: html.render())
        }
        
        private func menu(main: [Note], from lists: [NoteList]) -> [MenuItemViewModel] {
            let trashed = lists.first(where: { $0.title == "Trashed" })
            let archived = lists.first(where: { $0.title == "Archived" })
            let tasks = lists.first(where: { $0.title == "Tasks" })
            let untagged = lists.first(where: { $0.title == "Untagged" })
            
            return [
                MenuItemViewModel(name: "Notes", fullPath: "all", notesCount: main.count, children: [
                    MenuItemViewModel(name: "Untagged", fullPath: "untagged", notesCount: untagged!.notes.count, children: [], icon: .tag),
                    MenuItemViewModel(name: "Tasks", fullPath: "tasks", notesCount: tasks!.notes.count, children: [], icon: .checkbox)
                ], icon: .note),
                MenuItemViewModel(name: "Archived", fullPath: "archived", notesCount: archived!.notes.count, children: [], icon: .archive),
                MenuItemViewModel(name: "Trashed", fullPath: "trashed", notesCount: trashed!.notes.count, children: [], icon: .bin)
            ]
        }
    }

    struct NoteRenderer: BearSiteRenderer.NoteRenderer {
        let parser: (String) -> String
        func render(title: String, slug: String, content: String) -> Resource {
            let html = NoteHTML(title: title, slug: slug, content: parser(content))
            return Resource(filename: "standalone/note/\(slug).html", contents: html.render())
        }
    }

    
    struct CategoryListRenderer: BearSiteRenderer.ListRenderer {
        func render(title: String, slug: String, notes: [Note]) -> Resource {
            let html = NoteListHTML(title: title, notes: notes.map(NoteMapper.map))
            return Resource(filename: "standalone/list/\(slug).html", contents: html.render())
        }
    }
    
    struct TagListRenderer: BearSiteRenderer.ListRenderer {
        func render(title: String, slug: String, notes: [Note]) -> Resource {
            let html = NoteListHTML(title: title, notes: notes.map(NoteMapper.map))
            return Resource(filename: "standalone/tag/\(slug).html", contents: html.render())
        }
    }
    
    static func assetsProvider() -> [Resource] {
        IndexHTML.static().map(ResourceMapper.map)
    }
}

extension BearDb {
    func imgProcessor(_ img: String) -> String {
        guard let id = try? getFileId(with: img.removingPercentEncoding ?? img) else {
            return "<p>id not found for \(img)</p>"
        }
        
        return """
       <img src="/images/\(id)/\(img)"/>
       """
    }
}

import BearWebUI

extension BearDb {
    func hashtagProcessor(_ hashtag: String) -> String {
        NoteContentView.Hashtag(hashtag: hashtag, count: getHashtagCount(hashtag)).render()
    }
}


extension BearDb {
    func fileblockProcessor(_ title: String) -> String {
          guard let data = try? getFileData(from: title) else {
              return "@todo: Error, handle this case"
          }
          
        let domainObject: File = FileMapper.map(data)
        let uiObject: FileViewModel = FileMapper.map(domainObject)
        return FileBlock.Renderer(data: uiObject).render()
      }
}


