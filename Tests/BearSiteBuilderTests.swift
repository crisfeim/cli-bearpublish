// © 2025  Cristian Felipe Patiño Rojas. Created on 13/6/25.

import XCTest
import BearDomain

class BearSiteBuilderTests: XCTestCase {
    
    struct BearSite {
        let notes: [Note]
        let listsByCategory: [NoteList]
    }
    
    struct BearSiteBuilder {
        typealias NotesProvider = () throws -> [Note]
        typealias NoteListProvider = () throws -> [NoteList]
        typealias TagsProvider = () throws -> [Tag]
        
        let notesProvider: NotesProvider
        let listsByCategoryProvider: NoteListProvider
        let listsByTagProvider: NoteListProvider
        let tagsProvider: TagsProvider
        func execute() throws -> BearSite {
            let notes = try notesProvider()
            let listsByCategory = try listsByCategoryProvider()
            _ = try listsByTagProvider()
            _ = try tagsProvider()
            return BearSite(
                notes: notes,
                listsByCategory: listsByCategory
            )
        }
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
        
        XCTAssertEqual(site.notes, [stubedNote])
    }
    
    func test_execute_deliversSiteWithProvidedListsByCategoryOnProviderSuccess() throws {
        let stubedNoteList = anyNoteList()
        let sut = makeSUT(listsByCategoryProvider: { [stubedNoteList] })
        let site = try sut.execute()
        
        XCTAssertEqual(site.listsByCategory, [stubedNoteList])
    }
}
    
private extension BearSiteBuilderTests {
    typealias SUT = BearSiteBuilder
     func makeSUT(
        notesProvider: @escaping SUT.NotesProvider = anyProviderDummy,
        listsByCategoryProvider: @escaping SUT.NoteListProvider = anyProviderDummy,
        listsByTagProvider: @escaping SUT.NoteListProvider = anyProviderDummy,
        tagsProvider: @escaping SUT.TagsProvider = anyProviderDummy
    ) -> SUT {
        SUT(
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
}

fileprivate func anyProviderDummy<T>() throws -> [T] {[T]()}
