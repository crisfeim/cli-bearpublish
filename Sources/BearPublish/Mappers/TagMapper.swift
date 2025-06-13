// © 2025  Cristian Felipe Patiño Rojas. Created on 9/6/25.

import BearDatabase
import BearDomain

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
}
