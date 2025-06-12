// © 2025  Cristian Felipe Patiño Rojas. Created on 3/6/25.

import ArgumentParser
import Foundation
import BearPublish

@main
struct BearPublisherCLI: AsyncParsableCommand {
    
    @Option(name: .shortAndLong, help: "The Bear sqlite database path") var dbPath: String
    @Option(name: .shortAndLong, help: "The site's build path") var outputPath: String

    func run() async throws {
        let outputURL = URL(fileURLWithPath: outputPath)
        let sut = try BearSiteComposer.compose(dbPath: dbPath, outputURL: outputURL)
        try await sut.build()
    }
}
