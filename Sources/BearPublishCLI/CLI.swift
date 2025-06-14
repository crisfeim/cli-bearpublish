// © 2025  Cristian Felipe Patiño Rojas. Created on 3/6/25.

import ArgumentParser
import Foundation
import BearPublish

@main
struct BearPublisherCLI: AsyncParsableCommand {
    
    @Option(name: .shortAndLong, help: "The Bear sqlite database path") var input: String = "/Users/\(NSUserName())/Library/Group Containers/9K33E3U3T4.net.shinyfrog.bear/Application Data/database.sqlite"
    @Option(name: .shortAndLong, help: "The site's build path") var output: String = "dist"
    @Option(name: .shortAndLong, help: "The site's title") var title: String = "Home"

    func run() async throws {
        let outputURL = URL(fileURLWithPath: output)
        let publisher = try BearPublisherComposer.make(dbPath: input, outputURL: outputURL, siteTitle: title)
        try await publisher.execute()
    }
}
