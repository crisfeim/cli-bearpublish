// © 2025  Cristian Felipe Patiño Rojas. Created on 4/6/25.

public struct Tag: Equatable {
    public let name: String
    public let fullPath: String
    public let notesCount: Int
    public let children: [Tag]
    public let isPinned: Bool
    
    public init(name: String, fullPath: String, notesCount: Int, children: [Tag], isPinned: Bool) {
        self.name = name
        self.fullPath = fullPath
        self.notesCount = notesCount
        self.children = children
        self.isPinned = isPinned
    }
}
