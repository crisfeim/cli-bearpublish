// © 2025  Cristian Felipe Patiño Rojas. Created on 13/6/25.

import XCTest
import BearPublish
import BearDomain

class BearSiteBuilderTests: XCTestCase {
    
    func test_execute_deliversSiteWithGivenTitle() throws {
        let sut = makeSUT(sitesTitle: "site's title")
        let site = try sut.execute()
        XCTAssertEqual(site.title, "site's title")
    }
    
    func test_execute_deliversErrorOnIndexNotesProviderError() throws {
        let sut = makeSUT(indexNotesProvider: anyThrowingProvider)
        XCTAssertThrowsError(try sut.execute())
    }
    
    func test_execute_deliversErrorOnNotesProviderError() throws {
        let sut = makeSUT(notesProvider: anyThrowingProvider)
        XCTAssertThrowsError(try sut.execute())
    }
    
    func test_execute_deliversErrorOnListsByCategoryProviderError() throws {
        let sut = makeSUT(listsByCategoryProvider: anyThrowingProvider)
        XCTAssertThrowsError(try sut.execute())
    }
    
    func test_execute_deliversErrorOnListsByTagProviderError() throws {
        let sut = makeSUT(listsByTagProvider: anyThrowingProvider)
        XCTAssertThrowsError(try sut.execute())
    }
    
    func test_execute_deliversErrorOnTagProviderError() throws {
        let sut = makeSUT(tagsProvider: anyThrowingProvider)
        XCTAssertThrowsError(try sut.execute())
    }
    
    func test_execute_deliversSiteWithProvidedTitleOnNotesProviderSuccess() throws {
        let stubedNote = anyNote()
        let sut = makeSUT(notesProvider: { [stubedNote] })
        let site = try sut.execute()
        
        XCTAssertEqual(site.allNotes, [stubedNote])
    }
    
    func test_execute_deliversSiteWithProvidedListsByCategoryOnProviderSuccess() throws {
        let stubedNoteList = anyNoteList()
        let sut = makeSUT(listsByCategoryProvider: { [stubedNoteList] })
        let site = try sut.execute()
        
        XCTAssertEqual(site.listsByCategory, [stubedNoteList])
    }
    
    func test_execute_deliversSiteWithProvidedListsByTagOnProviderSuccess() throws {
        let stubedNoteList = anyNoteList()
        let sut = makeSUT(listsByTagProvider: { [stubedNoteList] })
        let site = try sut.execute()
        
        XCTAssertEqual(site.listsByTag, [stubedNoteList])
    }
    
    func test_execute_deliversSiteWithProvidedTagsOnProviderSuccess() throws {
        let stubedTag = anyTag()
        let sut = makeSUT(tagsProvider: { [stubedTag] })
        let site = try sut.execute()
        
        XCTAssertEqual(site.tags, [stubedTag])
    }    
}
    
private extension BearSiteBuilderTests {
    typealias SUT = BearSiteBuilder
     func makeSUT(
        sitesTitle: String = "any title",
        indexNotesProvider: @escaping SUT.NotesProvider = anyProviderDummy,
        notesProvider: @escaping SUT.NotesProvider = anyProviderDummy,
        listsByCategoryProvider: @escaping SUT.NoteListProvider = anyProviderDummy,
        listsByTagProvider: @escaping SUT.NoteListProvider = anyProviderDummy,
        tagsProvider: @escaping SUT.TagsProvider = anyProviderDummy
    ) -> SUT {
        SUT(
            sitesTitle: sitesTitle,
            indexNotesProvider: indexNotesProvider,
            notesProvider: notesProvider,
            listsByCategoryProvider: listsByCategoryProvider,
            listsByTagProvider: listsByTagProvider,
            tagsProvider: tagsProvider
        )
    }

    func anyThrowingProvider<T>() throws -> [T] {
        throw NSError(domain: "any error", code: 0)
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
            creationDate: nil,
            modificationDate: nil,
            content: "any note content"
        )
    }
    
    func anyNoteList() -> NoteList {
        NoteList(title: "any note list", slug: "any-note-list", notes: [anyNote()])
    }
    
    func anyTag() -> Tag {
        Tag(name: "any tag", fullPath: "any-tag", notesCount: 0, children: [], isPinned: false)
    }
}

fileprivate func anyProviderDummy<T>() throws -> [T] {[T]()}
