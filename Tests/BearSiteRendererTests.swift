// © 2025  Cristian Felipe Patiño Rojas. Created on 13/6/25.

import XCTest
import BearDomain
import BearPublish

class BearSiteRendererTests: XCTestCase {
    
    struct BearRenderedSite {
        let index: Resource
        let notes: [Resource]
    }
    
    struct BearSiteRenderer {
       
        protocol IndexRenderer {
            func render(title: String, lists: [NoteList], notes: [Note], tags: [Tag]) -> Resource
        }
        
        protocol NoteRenderer {
            func render(title: String, slug: String, content: String) -> Resource
        }
        
        let site: BearSite
        let indexRenderer: IndexRenderer
        let noteRenderer: NoteRenderer
        
        func execute() -> BearRenderedSite {
            BearRenderedSite(
                index: indexRenderer.render(
                    title: site.title,
                    lists: site.listsByCategory,
                    notes: site.notes,
                    tags: site.tags
                ),
                notes: site.notes.map(renderNote)
            )
        }
        
        func renderNote(_ note: Note) -> Resource {
            noteRenderer.render(
                title: note.title,
                slug: note.slug,
                content: note.content
            )
        }
    }
    
    func test_execute_passesCorrectArgumentsToIndexRenderer() throws {
        let renderer = IndexRendererSpy()
        let site = anyBearSite()
        let sut = BearSiteRenderer(
            site: site,
            indexRenderer: renderer,
            noteRenderer: NoteRendererDummy()
        )
        let _ = sut.execute()
        
        XCTAssertEqual(renderer.capturedTitle, site.title)
        XCTAssertEqual(renderer.capturedNotes, site.notes)
        XCTAssertEqual(renderer.capturedLists, site.listsByCategory)
        XCTAssertEqual(renderer.capturedTags, site.tags)
    }
    
    func test_execute_deliversRenderedIndexResourceFromIndexRenderer() throws {
        let stub = Resource(filename: "index.html", contents: "index contents")
        let renderer = IndexRendererStub(stub: stub)
        let site = anyBearSite()
        let sut = BearSiteRenderer(
            site: site,
            indexRenderer: renderer,
            noteRenderer: NoteRendererDummy()
        )
        let rendered = sut.execute()
        
        XCTAssertEqual(rendered.index, stub)
    }
    
    func test_execute_passCorrectArgumentsToNoteRenderer() throws {
        let renderer = NoteRendererSpy()
        let stubbedNotes = [anyNote(), anyNote(), anyNote(), anyNote()]
        let site = anyBearSite(notes: stubbedNotes)
        let sut = BearSiteRenderer(
            site: site,
            indexRenderer: IndexRendererDummy(),
            noteRenderer: renderer
        )
        _ = sut.execute()
        
        XCTAssertEqual(renderer.capturedNotes, stubbedNotes.map {
            NoteRendererSpy.Captured(title: $0.title, slug: $0.slug, content: $0.content)
        })
    }
    
    func test_execute_deliversRenderedNotesFromNoteRenderer() throws {
        let stubbedResource = Resource(filename: "note/somenote.html", contents: "any notes content")
        let renderer = NoteRendererStub(stub: stubbedResource)
        let stubbedNotes = [anyNote(), anyNote(), anyNote(), anyNote()]
        let site = anyBearSite(notes: stubbedNotes)
        let sut = BearSiteRenderer(
            site: site,
            indexRenderer: IndexRendererDummy(),
            noteRenderer: renderer
        )
        let rendered = sut.execute()
        
        XCTAssertEqual(rendered.notes, stubbedNotes.map { _ in stubbedResource })
    }
}

private extension BearSiteRendererTests {
    func anyBearSite(notes: [Note] = [anyNote()]) -> BearSite {
        BearSite(
            title: "title",
            notes: notes,
            tags: [anyTag()],
            listsByCategory: [anyNoteList(), anyNoteList()],
            listsByTag: [anyNoteList()]
        )
    }
    
    static func anyNote() -> Note {
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
    
    func anyNote() -> Note {
        Self.anyNote()
    }
    
    func anyNoteList() -> NoteList {
        NoteList(title: "any note list", slug: "any-note-list", notes: [anyNote()])
    }
    
    func anyTag() -> Tag {
        Tag(name: "any tag", fullPath: "any-tag", notesCount: 0, children: [], isPinned: false)
    }
    
    struct IndexRendererDummy: BearSiteRenderer.IndexRenderer {
        func render(title: String, lists: [NoteList], notes: [Note], tags: [Tag]) -> Resource {
            Resource(filename: "", contents: "")
        }
    }
    
    struct IndexRendererStub: BearSiteRenderer.IndexRenderer {
        let stub: Resource
        func render(title: String, lists: [NoteList], notes: [Note], tags: [Tag]) -> Resource {
            stub
        }
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
    
    class NoteRendererSpy: BearSiteRenderer.NoteRenderer {
        struct Captured: Equatable {
            let title: String
            let slug: String
            let content: String
        }
        
        var capturedNotes = [Captured]()
        func render(title: String, slug: String, content: String) -> Resource {
            capturedNotes.append(Captured(title: title, slug: slug, content: content))
            return  Resource(filename: "", contents: "")
        }
    }
    
    struct NoteRendererStub: BearSiteRenderer.NoteRenderer {
        let stub: Resource
        func render(title: String, slug: String, content: String) -> Resource {
            stub
        }
    }
    
    struct NoteRendererDummy: BearSiteRenderer.NoteRenderer {
        func render(title: String, slug: String, content: String) -> Resource {
            Resource(filename: "", contents: "")
        }
    }
}
