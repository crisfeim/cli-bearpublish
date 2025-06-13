// © 2025  Cristian Felipe Patiño Rojas. Created on 13/6/25.

import XCTest
import BearDomain

class BearSiteBuilderTests: XCTestCase {
    
    struct BearSiteBuilder {
        let notesProvider: () throws -> [Note]
        let listsByCategoryProvider: () throws -> [NoteList]
        let listsByTagProvider: () throws -> [NoteList]
        func execute() throws {
           _ = try notesProvider()
           _ = try listsByCategoryProvider()
            _ = try listsByTagProvider()
        }
    }
    
    func test_execute_deliversErrorOnNotesProviderError() throws {
        let sut = BearSiteBuilder(notesProvider: {
            throw NSError(domain: "any error", code: 0)
        }, listsByCategoryProvider: anyProviderDummy, listsByTagProvider: anyProviderDummy)
        
        XCTAssertThrowsError(try sut.execute())
    }
    
    func test_execute_deliversErrorOnListsByCategoryProviderError() throws {
        let sut = BearSiteBuilder(notesProvider: anyProviderDummy, listsByCategoryProvider: {
            throw NSError(domain: "any error", code: 0)
        }, listsByTagProvider: anyProviderDummy)
        
        XCTAssertThrowsError(try sut.execute())
    }
    
    func test_execute_deliversErrorOnListsByTagProviderError() throws {
        let sut = BearSiteBuilder(
            notesProvider: anyProviderDummy,
            listsByCategoryProvider: anyProviderDummy,
            listsByTagProvider: {
                throw NSError(domain: "any error", code: 0)
            }
        )
        
        XCTAssertThrowsError(try sut.execute())
    }
    
    func anyProviderDummy<T>() throws -> [T] {[T]()}
}
