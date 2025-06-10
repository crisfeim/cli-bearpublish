// © 2025  Cristian Felipe Patiño Rojas. Created on 9/6/25.

import XCTest
import BearPublish
import BearDomain

class NotesMakerTests: XCTestCase {
    typealias SUT = NotesMaker
    func test_make_deliversRenderedNoteDetails() throws {
        let renderer = RendererStub(result: "any note content")
        let router: SUT.Router = { "standalone/note/\($0).html" }
        let sut = makeSUT(notes: [anyNote()], parser: ParserDummy(), renderer: renderer, router: router)
        let notes = sut()
        let expected = [Resource(filename: "standalone/note/any-slug.html", contents: "any note content")]
        
        XCTAssertEqual(notes, expected)
    }
    
    func test_make_callsParser() throws {
        let parser = ParserSpy()
        let sut = makeSUT(notes: [anyNote()], parser: parser, renderer: RendererDummy(), router: routerDummy())
        _ = sut()
        
        XCTAssertEqual(parser.callCount, 1)
    }
    
    
    private func makeSUT(notes: [Note], parser: SUT.Parser, renderer: SUT.Renderer, router: @escaping SUT.Router) -> SUT {
        SUT(notes: notes, parser: parser, renderer: renderer, router: router)
    }
    
    private func routerDummy() -> (String) -> String {{ _ in "" }}
    
    class ParserSpy: SUT.Parser {
        var callCount = 0
        func parse(_ string: String) -> String { callCount += 1 ; return ""}
    }
    
    struct ParserDummy: SUT.Parser {
        func parse(_ string: String) -> String { return ""}
    }
    
    struct RendererDummy: SUT.Renderer {
        func render(title: String, slug: String, content: String) -> String {""}
    }
    
    struct RendererStub: SUT.Renderer {
        let result: String
        func render(title: String, slug: String, content: String) -> String {result}
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
