// © 2025  Cristian Felipe Patiño Rojas. Created on 15/6/25.


import Plot
import Foundation

public struct FileViewModel {
    public let id: String
    public let name: String
    public let creationDate: String
    public let ext: String
    public let size: Int
    
    public init(id: String, name: String, creationDate: String, ext: String, size: Int) {
        self.id = id
        self.name = name
        self.creationDate = creationDate
        self.ext = ext
        self.size = size
    }
}
