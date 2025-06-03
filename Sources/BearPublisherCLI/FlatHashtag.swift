//
//  File.swift
//  
//
//  Created by Cristian Felipe Patiño Rojas on 08/09/2023.
//

import Foundation

import BearPublisherDataSource

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
