// © 2025  Cristian Felipe Patiño Rojas. Created on 13/6/25.

import XCTest
import BearDomain

class BearSiteBuilderTests: XCTestCase {
    
    struct BearSiteBuilder {
        let notesProvider: () throws -> [Note]
        let listsByCategoryProvider: () throws -> [NoteList]
        func execute() throws {
           _ = try notesProvider()
           _ = try listsByCategoryProvider()
        }
    }
    
    func test_execute_deliversErrorOnNotesProviderError() throws {
        let sut = BearSiteBuilder(notesProvider: {
            throw NSError(domain: "any error", code: 0)
        }, listsByCategoryProvider: {[]})
        
        XCTAssertThrowsError(try sut.execute())
    }
    
    func test_execute_deliversErrorOnListsByCategoryProviderError() throws {
        let sut = BearSiteBuilder(notesProvider: {[]}, listsByCategoryProvider: {
            throw NSError(domain: "any error", code: 0)
        })
        
        XCTAssertThrowsError(try sut.execute())
    }
    
}
