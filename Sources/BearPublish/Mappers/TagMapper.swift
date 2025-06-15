// © 2025  Cristian Felipe Patiño Rojas. Created on 9/6/25.

import BearDatabase
import BearDomain
import BearWebUI

enum TagMapper {
    static func map(_ hashtag: DBTag) -> Tag {
        Tag(
            name: hashtag.name,
            fullPath: hashtag.path.replacingOccurrences(of: "/", with: "&"),
            notesCount: hashtag.count,
            children: hashtag.children.map(Self.map),
            isPinned: hashtag.isPinned
        )
    }
    
    static func map(_ tag: Tag) -> MenuItemViewModel {
        MenuItemViewModel(
            name: tag.name,
            fullPath: tag.fullPath,
            notesCount: tag.notesCount,
            children: tag.children.map(Self.map),
            icon: .tag
        )
    }
}
