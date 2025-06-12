// © 2025  Cristian Felipe Patiño Rojas. Created on 9/6/25.

import Foundation
import BearWebUI
import BearDatabase
import BearDomain
import BearMarkdown

public enum BearSiteComposer {
    public static func compose(dbPath: String, outputURL: URL) throws -> BearSite {
        
        let bearDb = try BearDb(path: dbPath)
        let parser = BearMarkdown(
            slugify: slugify,
            imgProcessor: bearDb.imgProcessor,
            hashtagProcessor: bearDb.hashtagProcessor,
            fileBlockProcessor: bearDb.fileblockProcessor
        )
        
        let noteListProvider = DefaultNoteListProvider(bearDb: bearDb)
        let tagProvider = TagsProvider(bearDb: bearDb)
        let notesProvider = NotesProvider(bearDb: bearDb)
        
        let index = IndexMaker(
            notes: try noteListProvider.get(),
            tags: try tagProvider.get(),
            renderer: IndexRenderer()
        )
        
        let notes = NotesMaker(
            notes: try notesProvider.get(),
            parser: parser,
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
        
        let assets = IndexHTML.static().map(ResourceMapper.map)
        
        return BearSite(
            index: index,
            notes: notes,
            listsByCategory: noteLists,
            listsByHashtag: noteListsForTags,
            assets: assets,
            outputURL: outputURL
        )
    }
}

extension BearMarkdown: NotesMaker.Parser {}
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
        ContentView.Hashtag(hashtag: hashtag, count: getHashtagCount(hashtag)).render()
    }
}


extension BearDb {
    func fileblockProcessor(_ title: String) -> String {
          guard let data = try? getFileData(from: title) else {
              return "@todo: Error, handle this case"
          }
          
        return FileBlock.Renderer(data: FileMapper.map(data)).render()
      }
}


