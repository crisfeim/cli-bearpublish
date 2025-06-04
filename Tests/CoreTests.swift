//// © 2025  Cristian Felipe Patiño Rojas. Created on 3/6/25.
//
//import XCTest
//
//class CoreTests: XCTestCase {
//    
//    struct Coordinator {
//        protocol Api {
//            func getIndex() throws -> Resource
//        }
//        
//        let api: Api
//        func getIndex() throws -> Resource {
//        }
//    }
//    
//    func test_getIndex_deliversExpectedResource() throws {
//        let sut = Coordinator()
//        let index = try sut.getIndex()
//        let expectedIndex = Resource(filename: "index.html", contents: "")
//        XCTAssertEqual(index, expectedIndex)
//    }
//    
//}
