// © 2025  Cristian Felipe Patiño Rojas. Created on 4/6/25.


public struct Tag {
    public let id: Int
    public let title: String
    public let tagCon: String
    public let count: Int
    public let slug: String
    public let childs: [Tag]
    
    public init(id: Int, title: String, tagCon: String, count: Int, slug: String, childs: [Tag]) {
        self.id = id
        self.title = title
        self.tagCon = tagCon
        self.count = count
        self.slug = slug
        self.childs = childs
    }
}
