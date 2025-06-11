// © 2025  Cristian Felipe Patiño Rojas. Created on 11/6/25.
import Foundation

public struct File {
    public let id: String
    public let name: String
    public let date: Date?
    public let `extension`: String
    public let size: Int
    
    public init(id: String, name: String, date: Date? = nil, `extension`: String, size: Int) {
        self.id = id
        self.name = name
        self.date = date
        self.`extension` = `extension`
        self.size = size
    }
}
