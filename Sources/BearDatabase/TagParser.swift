//
//  File.swift
//  
//
//  Created by Cristian Felipe Patiño Rojas on 02/06/2023.
//

import Foundation

public enum TagParser {
    public typealias Tag = Hashtag
    
    public static func parse(tags: [Tag]) -> [Tag] {
        var mergedTags: [Tag] = []
        
        for tag in tags {
            mergeTag(tag, into: &mergedTags)
        }
        
        return mergedTags
    }

    public static func mergeTag(_ tag: Tag, into mergedTags: inout [Tag]) {
        if let index = mergedTags.firstIndex(where: { $0.name == tag.name }) {
            var mergedTag = mergedTags[index]
            mergedTag.isPinned = mergedTag.isPinned || tag.isPinned
            
            for child in tag.children {
                mergeTag(child, into: &mergedTag.children)
            }
            
            mergedTags[index] = mergedTag
        } else {
            mergedTags.append(tag)
        }
    }
    
    
    public static func makeTag(from string: String, count: Int, isPinned: Bool) -> Hashtag? {
        var array = string.splitted()
        var tag: Hashtag?
        
        while !array.isEmpty {
            let slug = array.joined(separator: "/")
            array.removeLast()
            
            if let safeTag = tag {
                tag = .init(
                    path: slug,
                    count: count,
                    isPinned: isPinned,
                    children: [safeTag]
                )
            } else {
                tag = .init(
                    path: slug,
                    count: count,
                    isPinned: isPinned,
                    children: []
                )
            }
        }
        
        return tag
    }
}

extension String {
    func splitted() -> [String] {components(separatedBy: "/")}
}
