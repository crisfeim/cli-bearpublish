// © 2025  Cristian Felipe Patiño Rojas. Created on 4/6/25.


import Foundation

public struct DBTag {
    public let id      : UUID
    public let path    : String
    public let count   : Int
    public var isPinned: Bool
    public var children: [Self]
    
    public var name    : String { components.last! }
    public var ancestor: String { components.first! }
    private var components: [String] { path.components(separatedBy: "/") }
    
    public init(
        path: String,
        count: Int,
        isPinned: Bool,
        children: [DBTag]
    ) {
        self.id = UUID()
        self.path = path
        self.count = count
        self.isPinned = isPinned
        self.children = children
    }
}
