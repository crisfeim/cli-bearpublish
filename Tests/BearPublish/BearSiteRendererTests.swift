// © 2025  Cristian Felipe Patiño Rojas. Created on 13/6/25.

import XCTest
import BearDomain
import BearPublish

class BearSiteRendererTests: XCTestCase {
    
    func test_execute_passesCorrectArgumentsToIndexRenderer() throws {
        let renderer = IndexRendererSpy()
        let site = anyBearSite()
        let sut = makeSUT(site: site, indexRenderer: renderer)
        let _ = sut.execute()
        
        XCTAssertEqual(renderer.capturedTitle, site.title)
        XCTAssertEqual(renderer.capturedNotes, site.indexNotes)
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

    func test_execute_deliversRenderedListsByTagFromListByTagRenderer() throws {
        let stubbedResource = Resource(filename: "tag/somelist.html", contents: "any list contents")
        let renderer = ListRendererStub(stub: stubbedResource)
        let stubbedList = [anyNoteList(), anyNoteList()]
        let site = anyBearSite(listsByTag: stubbedList)
        
        let sut = makeSUT(site: site, listByTagRenderer: renderer)
        let rendered = sut.execute()
        
        XCTAssertEqual(rendered.listsByTag, stubbedList.map { _ in stubbedResource })
    }
    
    func test_execute_passCorrectArgumentsToListByTagRenderer() throws {
        let renderer = ListRendererSpy()
        let stubbedList = [anyNoteList()]
        
        let site = anyBearSite(listsByTag: stubbedList)
        let sut = makeSUT(site: site, listByTagRenderer: renderer)
        _ = sut.execute()
        
        XCTAssertEqual(
            renderer.capturedLists, stubbedList.map {
                ListRendererSpy.Captured(title: $0.title, slug: $0.slug, notes: $0.notes)
            }
        )
    }
    
    func test_execute_deliversRenderedListsByCategoryFromListByCategoryRenderer() throws {
        let stubbedResource = Resource(filename: "list/somelist.html", contents: "any list contents")
        let renderer = ListRendererStub(stub: stubbedResource)
        let stubbedListsByCategory = [anyNoteList(), anyNoteList()]
        let site = anyBearSite(listsByCategory: stubbedListsByCategory)
        
        let sut = makeSUT(site: site, listByCategoryRenderer: renderer)
        let rendered = sut.execute()
        
        XCTAssertEqual(rendered.listsByCategory, stubbedListsByCategory.map { _ in stubbedResource })
    }
    
    func test_execute_passCorrectArgumentsToListByCategoryRenderer() throws {
        let renderer = ListRendererSpy()
        let stubbedList = [anyNoteList()]
        
        let site = anyBearSite(listsByCategory: stubbedList)
        let sut = makeSUT(site: site, listByCategoryRenderer: renderer)
        _ = sut.execute()
        
        XCTAssertEqual(
            renderer.capturedLists, stubbedList.map {
                ListRendererSpy.Captured(title: $0.title, slug: $0.slug, notes: $0.notes)
            }
        )
    }
    
    
    func test_execute_deliversAssetsFromAssetsProvider() throws {
        let sut = makeSUT(site: anyBearSite(), assetsProvider: {[
            Resource(filename: "css/somecss.css", contents: "somecss contents")
        ]})
        
        let rendered = sut.execute()
        XCTAssertEqual(rendered.assets, [Resource(filename: "css/somecss.css", contents: "somecss contents")])
    }
}

private extension BearSiteRendererTests {
    typealias SUT = BearSiteRenderer
    func makeSUT(
        site: BearSite,
        indexRenderer: SUT.IndexRenderer = IndexRendererDummy(),
        noteRenderer: SUT.NoteRenderer = NoteRendererDummy(),
        listByCategoryRenderer: SUT.ListRenderer = ListRendererDummy(),
        listByTagRenderer: SUT.ListRenderer = ListRendererDummy(),
        assetsProvider: @escaping SUT.AssetsProvider = { [ ] }
    ) -> SUT {
        SUT(
            site: site,
            indexRenderer: indexRenderer,
            noteRenderer: noteRenderer,
            listsByCategoryRenderer: listByCategoryRenderer,
            listsByTagRenderer: listByTagRenderer,
            assetsProvider: assetsProvider
        )
    }
    
    func anyBearSite(
        indexNotes: [Note] = [anyNote()],
        notes: [Note] = [anyNote()],
        tags: [Tag] = [anyTag()],
        listsByCategory: [NoteList] = [anyNoteList()],
        listsByTag: [NoteList] = [anyNoteList()]
    ) -> BearSite {
        BearSite(
            title: "title",
            indexNotes: indexNotes,
            allNotes: notes,
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
            let slug: String
            let notes: [Note]
        }
        var capturedLists = [Captured]()
        
        func render(title: String, slug: String, notes: [Note]) -> Resource {
            capturedLists.append(Captured(title: title, slug: slug, notes: notes))
            return Resource(filename: "", contents: "")
        }
    }
    
    struct ListRendererDummy: BearSiteRenderer.ListRenderer {
        func render(title: String, slug: String, notes: [Note]) -> Resource {
            Resource(filename: "", contents: "")
        }
    }
    
    struct ListRendererStub: BearSiteRenderer.ListRenderer {
        let stub: Resource
        func render(title: String, slug: String, notes: [Note]) -> Resource {
            stub
        }
    }
}
