// © 2025  Cristian Felipe Patiño Rojas. Created on 4/6/25.


import Foundation

public struct ResourceWriter {
    let resources: [Resource]
    let outputURL: URL
    
    public init(resources: [Resource], outputURL: URL) {
        self.resources = resources
        self.outputURL = outputURL
    }
    
    public func build() throws {
        try resources.forEach {
            let url = outputURL.appendingPathComponent($0.filename)
            let directory = url.deletingLastPathComponent()
            try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
            
            try $0.contents.write(to: url, atomically: true, encoding: .utf8)
        }
    }
}
