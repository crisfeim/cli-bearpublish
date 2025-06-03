// © 2025  Cristian Felipe Patiño Rojas. Created on 3/6/25.

import ArgumentParser
import Foundation

@main
struct CLI: ParsableCommand {
    
    @Option var destination: String
    mutating func run() throws {}
    
    func execute() throws {
        try copyDatabase()
       
        let ssg = SSG()
        let dbPath = "/Users/\(NSUserName())/Library/Containers/lat.cristian.Renard/Data/Applications/database.sqlite"
        try ssg.setupDb(location: dbPath)
        
        let destinationURL = URL(fileURLWithPath: destination)
        try? ssg.build(on: destinationURL) {}
    }
}
