// © 2025  Cristian Felipe Patiño Rojas. Created on 9/6/25.

import XCTest
import BearPublisherWeb

struct IndexRenderer: IndexMaker.Renderer {
    func render(notes: [Note], tags: [Tag]) -> String {
        let notes = notes.map { _ in
            BearPublisherWeb.NoteList.Model.init(
                id: 0,
                title: "",
                slug: "",
                isSelected: false,
                isPinned: false,
                isEncrypted: false,
                isEmpty: false,
                subtitle: "",
                creationDate: nil,
                modificationDate: nil
            )
        }
        BaseLayout(title: "", tags: [], notes: notes)
        return ""
    }
}


class IndexRendererTests: XCTestCase {
    
    
    func test() {
        let sut = IndexRenderer()
    }
}
