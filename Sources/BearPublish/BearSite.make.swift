// © 2025  Cristian Felipe Patiño Rojas. Created on 9/6/25.

import Foundation
import BearWebUI
import BearDatabase
import BearDomain
import BearMarkdown

extension BearSite {
    public static func make(dbPath: String, outputURL: URL) throws -> BearSite {
        
        let bearDb = try BearDb(path: dbPath)
        let parser = BearMarkdown(
            slugify: slugify,
            imgProcessor: bearDb.imgProcessor,
            hashtagProcessor: bearDb.hashtagProcessor,
            fileBlockProcessor: { _ in "" }
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
    
    func getHashtagCount(_ hashtag: String) -> Int {
        guard let tree = try? fetchTagTree() else { return 0 }
        return tree.flat().filter { $0.path == hashtag }.first?.count ?? 0
    }
    
}

//
//  File.swift
//
//
//  Created by Cristian Felipe Patiño Rojas on 08/09/2023.
//

/// Model used to flat a Hashtag tree to a non-node struct array.
/// This means that a tree as follows:
/// |- A
/// |- |- B
/// Will pe parsed to an array as follows: [A, A/B]
/// - Parameter path: Represents the path of the tag within the hierarchy. ex.: "/my/nested/hashtag"
struct FlatHashtag {
    let path: String
    let count: Int
}

extension [Hashtag] {
    
    /// Use to map a hashtag tree with nested Hashtags to an array of FlatHashtag
    func flat() -> [FlatHashtag] {
        self.reduce([FlatHashtag]()) { (result, hashtag) in
            let tag = FlatHashtag(path: hashtag.path, count: hashtag.count)
            var paths = result
            paths.append(tag)
            let childrens = hashtag.children.flat()
            paths.append(contentsOf: childrens)
            return paths
        }
    }
}
