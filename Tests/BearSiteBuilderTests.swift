// © 2025  Cristian Felipe Patiño Rojas. Created on 13/6/25.

import XCTest
import BearDomain

class BearSiteBuilderTests: XCTestCase {
    
    struct BearSiteBuilder {
        typealias NotesProvider = () throws -> [Note]
        typealias NoteListProvider = () throws -> [NoteList]
        typealias TagsProvider = () throws -> [Tag]
        
        let notesProvider: NotesProvider
        let listsByCategoryProvider: NoteListProvider
        let listsByTagProvider: NoteListProvider
        let tagsProvider: TagsProvider
        func execute() throws {
            _ = try notesProvider()
            _ = try listsByCategoryProvider()
            _ = try listsByTagProvider()
            _ = try tagsProvider()
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
}

fileprivate func anyProviderDummy<T>() throws -> [T] {[T]()}
