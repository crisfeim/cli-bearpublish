// © 2025  Cristian Felipe Patiño Rojas. Created on 13/6/25.

import XCTest
import BearDomain

class BearSiteBuilderTests: XCTestCase {
    
    struct BearSiteBuilder {
        let notesProvider: () throws -> [Note]
        func execute() throws {
           _ = try notesProvider()
        }
    }
    
    func test_execute_deliversErrorOnNotesProviderError() throws {
        
        let sut = BearSiteBuilder(notesProvider: {
            throw NSError(domain: "any error", code: 0)
        })
        
        XCTAssertThrowsError(try sut.execute())
    }
    
}
