// © 2025  Cristian Felipe Patiño Rojas. Created on 13/6/25.

import XCTest
import BearDomain
import BearPublish

class BearSiteRendererTests: XCTestCase {
    
    struct BearRenderedSite {
        let index: Resource
    }
    
    struct BearSiteRenderer {
       
        protocol IndexRenderer {
            func render(title: String, lists: [NoteList], notes: [Note], tags: [Tag]) -> Resource
        }
        
        let site: BearSite
        let indexRenderer: IndexRenderer
        
        func execute() -> BearRenderedSite {
            BearRenderedSite(
                index: indexRenderer.render(
                    title: site.title,
                    lists: site.listsByCategory,
                    notes: site.notes,
                    tags: site.tags
                )
            )
        }
    }
    
    func test_execute_passesCorrectArgumentsToIndexRenderer() throws {
        let renderer = IndexRendererSpy()
        let site = anyBearSite()
        let sut = BearSiteRenderer(site: site, indexRenderer: renderer)
        let _ = sut.execute()
        
        XCTAssertEqual(renderer.capturedTitle, site.title)
        XCTAssertEqual(renderer.capturedNotes, site.notes)
        XCTAssertEqual(renderer.capturedLists, site.listsByCategory)
        XCTAssertEqual(renderer.capturedTags, site.tags)
    }
}

private extension BearSiteRendererTests {
    func anyBearSite() -> BearSite {
        BearSite(
            title: "title",
            notes: [anyNote(), anyNote()],
            tags: [anyTag()],
            listsByCategory: [anyNoteList(), anyNoteList()],
            listsByTag: [anyNoteList()]
        )
    }
    
    func anyNote() -> Note {
        Note(
            id: 0,
            title: "any note",
            slug: "any slug",
            isPinned: false,
            isEncrypted: false,
            isEmpty: false,
            subtitle: "any subtitle",
            creationDate: Date(),
            modificationDate: Date(),
            content: "any note content"
        )
    }
    
    func anyNoteList() -> NoteList {
        NoteList(title: "any note list", slug: "any-note-list", notes: [anyNote()])
    }
    
    func anyTag() -> Tag {
        Tag(name: "any tag", fullPath: "any-tag", notesCount: 0, children: [], isPinned: false)
    }
    
    class IndexRendererSpy: BearSiteRenderer.IndexRenderer {
        
        var capturedTitle: String?
        var capturedLists: [NoteList] = []
        var capturedNotes: [Note] = []
        var capturedTags: [Tag] = []
        
        func render(title: String, lists: [NoteList], notes: [Note], tags: [Tag]) -> Resource {
            capturedTitle = title
            capturedLists = lists
            capturedNotes = notes
            capturedTags = tags
            return Resource(filename: "", contents: "")
        }
    }
}
