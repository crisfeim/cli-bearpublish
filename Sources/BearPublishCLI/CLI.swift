// © 2025  Cristian Felipe Patiño Rojas. Created on 3/6/25.

import ArgumentParser
import Foundation
import BearPublish

@main
struct BearPublisherCLI: AsyncParsableCommand {
    
    @Option(name: .shortAndLong, help: "The Bear sqlite database path") var input: String
    @Option(name: .shortAndLong, help: "The site's build path") var output: String
    @Option(name: .shortAndLong, help: "The site's title") var title: String

    func run() async throws {
        let outputURL = URL(fileURLWithPath: output)
        let publisher = try BearPublisherComposer.make(dbPath: input, outputURL: outputURL, siteTitle: title)
        try await publisher.execute()
    }
}
