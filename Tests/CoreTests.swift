// © 2025  Cristian Felipe Patiño Rojas. Created on 3/6/25.

import XCTest
import BearPublisherCLI

class CoreTests: XCTestCase {
    func test() throws {
       let sut = SSG()
        let desktopURL = FileManager.default.urls(for: .desktopDirectory, in: .userDomainMask).first!.appendingPathComponent("Export")
        try sut.build(on: desktopURL) {}
    }
}
