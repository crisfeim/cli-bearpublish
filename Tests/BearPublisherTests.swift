// © 2025  Cristian Felipe Patiño Rojas. Created on 13/6/25.

import XCTest

import BearDomain
import BearPublish

struct BearPublisher {
    
    let execute: () async throws -> Void
    
    init(
        outputURL: URL,
        siteTitle: String,
        notesProvider: @escaping () throws -> [Note],
        categoryListProvider: @escaping () throws -> [NoteList],
        tagListProvider: @escaping () throws -> [NoteList],
        tagProvider: @escaping () throws -> [Tag],
        indexRenderer: BearSiteRenderer.IndexRenderer,
        noteRenderer: BearSiteRenderer.NoteRenderer,
        listByCategoryRenderer: BearSiteRenderer.ListRenderer,
        listByTagRenderer: BearSiteRenderer.ListRenderer,
        assetsProvider: @escaping () -> [Resource]
    ) throws {
        let builder = BearSiteBuilder(
            sitesTitle: siteTitle,
            notesProvider: notesProvider,
            listsByCategoryProvider: categoryListProvider,
            listsByTagProvider: tagListProvider,
            tagsProvider: tagProvider
        )
        
        let renderer = BearSiteRenderer(
            site: try builder.execute(),
            indexRenderer: indexRenderer,
            noteRenderer: noteRenderer,
            listsByCategoryRenderer: listByCategoryRenderer,
            listsByTagRenderer: listByTagRenderer,
            assetsProvider: assetsProvider
        )
        
        execute = BearSiteGenerator(site: renderer.execute(), outputURL: outputURL).execute
    }
}

class BearPublisherTests: XCTestCase {

    func test_execute_buildsTheExpectedSiteAtOutputURL() async throws {
        struct IndexRenderer: BearSiteRenderer.IndexRenderer {
            func render(title: String, lists: [NoteList], notes: [Note], tags: [Tag]) -> Resource {
                Resource(filename: "index.html", contents: "index rendered contents")
            }
        }
        
        struct NoteRenderer: BearSiteRenderer.NoteRenderer {
            func render(title: String, slug: String, content: String) -> Resource {
                Resource(filename: "note/\(slug).html", contents: "note rendered content")
            }
        }
        
        struct ListByCategoryRenderer: BearSiteRenderer.ListRenderer {
            func render(title: String, slug: String, notes: [Note]) -> Resource {
                Resource(filename: "list/\(slug).html", contents: "list rendered content")
            }
        }
        
        struct ListByTagRenderer: BearSiteRenderer.ListRenderer {
            func render(title: String, slug: String, notes: [Note]) -> Resource {
                Resource(filename: "tag/\(slug).html", contents: "list rendered content")
            }
        }
        
        let sut = try BearPublisher(
            outputURL: testSpecificURL(),
            siteTitle: "Home",
            notesProvider: { [Self.anyNote()] },
            categoryListProvider: { [Self.anyNoteList()] },
            tagListProvider: { [Self.anyNoteList()] },
            tagProvider: { [Self.anyTag()] },
            indexRenderer: IndexRenderer(),
            noteRenderer: NoteRenderer(),
            listByCategoryRenderer: ListByCategoryRenderer(),
            listByTagRenderer: ListByTagRenderer(),
            assetsProvider: {
                [Resource(filename: "css/some.css", contents: "Some css")]
            })
        
        try await sut.execute()
        
        expectFileAtPathToExist("index.html")
        expectFileAtPathToExist("note/\(Self.anyNote().slug).html")
        expectFileAtPathToExist("list/\(Self.anyNoteList().slug).html")
        expectFileAtPathToExist("tag/\(Self.anyNoteList().slug).html")
        expectFileAtPathToExist("css/some.css")
    }
}


private extension BearPublisherTests {
    #warning("@todo: Assert file contets")
    func expectFileAtPathToExist(_ path: String, file: StaticString = #filePath, line: UInt = #line) {
        XCTAssert(FileManager.default.fileExists(atPath: testSpecificURL().appendingPathComponent(path).path))
    }
}

// MARK: - Helpers
#warning("@todo: Extract helpers into common scope")
private extension BearPublisherTests {
    
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
    
    static func anyNoteList() -> NoteList {
        NoteList(title: "any note list", slug: "any-note-list", notes: [anyNote()])
    }
    
    static func anyTag() -> Tag {
        Tag(name: "any tag", fullPath: "any-tag", notesCount: 0, children: [], isPinned: false)
    }
    
    func cachesDirectory() -> URL {
        return FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
    }
    
    func testSpecificURL() -> URL {
        cachesDirectory().appendingPathComponent("\(type(of: self))")
    }
}
