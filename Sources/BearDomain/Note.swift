// © 2025  Cristian Felipe Patiño Rojas. Created on 4/6/25.
import Foundation

public struct Note: Equatable {
    public let id: Int
    public let title: String
    public let slug: String
    public let isPinned: Bool
    public let isEncrypted: Bool
    public let isEmpty: Bool
    public let subtitle: String
    public let creationDate: Date
    public let modificationDate: Date?
    public let content: String
 
    public init(id: Int, title: String, slug: String, isPinned: Bool, isEncrypted: Bool, isEmpty: Bool, subtitle: String, creationDate: Date, modificationDate: Date?, content: String) {

        self.id = id
        self.title = title
        self.slug = slug
        self.isPinned = isPinned
        self.isEncrypted = isEncrypted
        self.isEmpty = isEmpty
        self.subtitle = subtitle
        self.creationDate = creationDate
        self.modificationDate = modificationDate
        self.content = content
    }
}
