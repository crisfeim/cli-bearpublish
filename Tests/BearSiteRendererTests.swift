// © 2025  Cristian Felipe Patiño Rojas. Created on 13/6/25.

import XCTest
import BearDomain
import BearPublish

class BearSiteRendererTests: XCTestCase {
    
    struct BearRenderedSite {
        let index: Resource
        let notes: [Resource]
        let listsByCategory: [Resource]
        let listsByTag: [Resource]
    }
    
    struct BearSiteRenderer {
       
        protocol IndexRenderer {
            func render(title: String, lists: [NoteList], notes: [Note], tags: [Tag]) -> Resource
        }
        
        protocol NoteRenderer {
            func render(title: String, slug: String, content: String) -> Resource
        }
        
        protocol ListRenderer {
            func render(title: String, notes: [Note]) -> Resource
        }
        
        let site: BearSite
        let indexRenderer: IndexRenderer
        let noteRenderer: NoteRenderer
        let listRenderer: ListRenderer
        
        func execute() -> BearRenderedSite {
            BearRenderedSite(
                index: indexRenderer.render(
                    title: site.title,
                    lists: site.listsByCategory,
                    notes: site.notes,
                    tags: site.tags
                ),
                notes: site.notes.map(renderNote),
                listsByCategory: site.listsByCategory.map(renderList),
                listsByTag: site.listsByTag.map(renderList)
            )
        }
        
        private func renderNote(_ note: Note) -> Resource {
            noteRenderer.render(
                title: note.title,
                slug: note.slug,
                content: note.content
            )
        }
        
        private func renderList(_ noteList: NoteList) -> Resource {
            listRenderer.render(title: noteList.title, notes: noteList.notes)
        }
    }
    
    func test_execute_passesCorrectArgumentsToIndexRenderer() throws {
        let renderer = IndexRendererSpy()
        let site = anyBearSite()
        let sut = makeSUT(site: site, indexRenderer: renderer)
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
        let sut = makeSUT(site: site, indexRenderer: renderer)
        let rendered = sut.execute()
        
        XCTAssertEqual(rendered.index, stub)
    }
    
    func test_execute_passCorrectArgumentsToNoteRenderer() throws {
        let renderer = NoteRendererSpy()
        let stubbedNotes = [anyNote(), anyNote(), anyNote(), anyNote()]
        let site = anyBearSite(notes: stubbedNotes)
        let sut = makeSUT(site: site, noteRenderer: renderer)
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
        let sut = makeSUT(site: site, noteRenderer: renderer)
        let rendered = sut.execute()
        
        XCTAssertEqual(rendered.notes, stubbedNotes.map { _ in stubbedResource })
    }
    
    func test_execute_passCorrectArgumentsToNoteListRenderer() throws {
        let renderer = ListRendererSpy()
        let stubbedListsByCategory = [anyNoteList()]
        let stubbedListsByTag = [anyNoteList()]
        
        let site = anyBearSite(listsByCategory: stubbedListsByCategory, listsByTag: stubbedListsByTag)
        let sut = makeSUT(site: site, listRenderer: renderer)
        _ = sut.execute()
        
        XCTAssertEqual(
            renderer.capturedLists,
            (stubbedListsByCategory + stubbedListsByTag).map {
                ListRendererSpy.Captured(title: $0.title, notes: $0.notes)
            }
        )
    }
    
    func test_execute_deliversRenderedNoteListsFromListRenderer() throws {
        let stubbedResource = Resource(filename: "list/somelist.html", contents: "any list contents")
        let renderer = ListRendererStub(stub: stubbedResource)
        let stubbedListsByCategory = [anyNoteList(), anyNoteList()]
        let stubbedListsByTag = [anyNoteList(), anyNoteList(), anyNoteList()]
        let site = anyBearSite(
            listsByCategory: stubbedListsByCategory,
            listsByTag: stubbedListsByTag
        )
        
        let sut = makeSUT(site: site, listRenderer: renderer)
        let rendered = sut.execute()
        
        XCTAssertEqual(rendered.listsByCategory, stubbedListsByCategory.map { _ in stubbedResource })
        XCTAssertEqual(rendered.listsByTag, stubbedListsByTag.map { _ in stubbedResource })
    }
}

private extension BearSiteRendererTests {
    typealias SUT = BearSiteRenderer
    func makeSUT(
        site: BearSite,
        indexRenderer: SUT.IndexRenderer = IndexRendererDummy(),
        noteRenderer: SUT.NoteRenderer = NoteRendererDummy(),
        listRenderer: SUT.ListRenderer = ListRendererDummy()
    ) -> SUT {
        SUT(
            site: site,
            indexRenderer: indexRenderer,
            noteRenderer: noteRenderer,
            listRenderer: listRenderer
        )
    }
    
    func anyBearSite(
        notes: [Note] = [anyNote()],
        tags: [Tag] = [anyTag()],
        listsByCategory: [NoteList] = [anyNoteList()],
        listsByTag: [NoteList] = [anyNoteList()]
    ) -> BearSite {
        BearSite(
            title: "title",
            notes: notes,
            tags: tags,
            listsByCategory: listsByCategory,
            listsByTag: listsByTag
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
        Self.anyNoteList()
    }
    
    static func anyNoteList() -> NoteList {
        NoteList(title: "any note list", slug: "any-note-list", notes: [anyNote()])
    }
    
    static func anyTag() -> Tag {
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
    
    class ListRendererSpy: BearSiteRenderer.ListRenderer {
        struct Captured: Equatable {
            let title: String
            let notes: [Note]
        }
        var capturedLists = [Captured]()
        
        func render(title: String, notes: [Note]) -> Resource {
            capturedLists.append(Captured(title: title, notes: notes))
            return Resource(filename: "", contents: "")
        }
    }
    
    struct ListRendererDummy: BearSiteRenderer.ListRenderer {
        func render(title: String, notes: [Note]) -> Resource {
            Resource(filename: "", contents: "")
        }
    }
    
    struct ListRendererStub: BearSiteRenderer.ListRenderer {
        let stub: Resource
        func render(title: String, notes: [Note]) -> Resource {
            stub
        }
    }
}
