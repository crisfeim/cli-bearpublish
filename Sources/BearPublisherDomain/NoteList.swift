// © 2025  Cristian Felipe Patiño Rojas. Created on 9/6/25.

public struct NoteList: Equatable {
    public let title: String
    public let slug: String
    public let notes: [Note]
    
    public init(title: String, slug: String, notes: [Note]) {
        self.title = title
        self.slug = slug
        self.notes = notes
    }
}
