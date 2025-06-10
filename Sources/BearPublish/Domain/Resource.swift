// © 2025  Cristian Felipe Patiño Rojas. Created on 4/6/25.

public struct Resource: Equatable {
    public let filename: String
    public let contents: String
    
    public init(filename: String, contents: String) {
        self.filename = filename
        self.contents = contents
    }
}
