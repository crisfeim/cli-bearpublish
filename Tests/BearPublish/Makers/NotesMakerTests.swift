// © 2025  Cristian Felipe Patiño Rojas. Created on 9/6/25.

import XCTest
import BearPublish
import BearDomain

class NotesMakerTests: XCTestCase {
    typealias SUT = NotesMaker
    func test_make_deliversRenderedNoteDetails() throws {
        let renderer = Renderer(result: "any note content")
        let router: SUT.Router = { "standalone/note/\($0).html" }
        let sut = makeSUT(notes: [anyNote()], renderer: renderer, router: router)
        let notes = sut()
        let expected = [Resource(filename: "standalone/note/any-slug.html", contents: "any note content")]
        
        XCTAssertEqual(notes, expected)
    }
    
    
    private func makeSUT(notes: [Note], renderer: SUT.Renderer, router: @escaping SUT.Router) -> SUT {
        SUT(notes: notes, renderer: renderer, router: router)
    }
    
    struct Renderer: SUT.Renderer {
        let result: String
        func render(_ note: Note) -> String {result}
    }
    
    func anyNote() -> Note {
        Note(
            id: 0,
            title: "any note",
            slug: "any-slug",
            isPinned: false,
            isEncrypted: false,
            isEmpty: false,
            subtitle: "any subtitle",
            creationDate: nil,
            modificationDate: nil,
            content: "any content"
        )
    }
}
