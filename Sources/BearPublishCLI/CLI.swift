// © 2025  Cristian Felipe Patiño Rojas. Created on 3/6/25.

import ArgumentParser
import Foundation

@main
struct CLI: ParsableCommand {
    
    @Option var destination: String
    mutating func run() throws {}
    
    func execute() throws {}
}
