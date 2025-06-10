// © 2025  Cristian Felipe Patiño Rojas. Created on 9/6/25.

import XCTest
import BearDomain

class NoteListMakerTests: XCTestCase {
    
    typealias SUT = NoteListMaker
    
    func test_make_deliversRenderedTaggedNoteLists() throws {
        
        let provider = ProviderStub(stub: [
            NoteList(title: "Any tag", slug: "any-tag", notes: [anyNote()])
        ])
        let renderer = RendererStub(result: "any rendered content")
        let router: SUT.Router = { "standalone/tag/\($0).html" }
        
        let sut = makeSUT(provider: provider, renderer: renderer, router: router)
        let resources = try sut()
        let expected = [Resource(filename: "standalone/tag/any-tag.html", contents: "any rendered content")]
        
        XCTAssertEqual(resources, expected)
    }
    
    
    func makeSUT(provider: SUT.Provider, renderer: SUT.Renderer, router: @escaping SUT.Router) -> SUT {
        SUT(provider: provider, renderer: renderer, router: router)
    }
    
    
    struct ProviderStub: SUT.Provider {
        let stub: [NoteList]
        func get() throws -> [NoteList] { stub }
    }
    
    struct RendererStub: SUT.Renderer {
        let result: String
        func render(_ list: NoteList) -> String { result }
    }
    
    func anyNote() -> Note {
        Note(
            id: 0,
            title: "any note",
            slug: "any-note",
            isPinned: false,
            isEncrypted: false,
            isEmpty: false,
            subtitle: "any subtitle",
            creationDate: Date(),
            modificationDate: Date(),
            content: "any content"
        )
    }
}
