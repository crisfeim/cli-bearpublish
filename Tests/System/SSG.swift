// © 2025  Cristian Felipe Patiño Rojas. Created on 4/6/25.


import Foundation

struct SSG {
    let resources: [Resource]
    let outputURL: URL
    
    func build() throws {
        try createOutputFolderIfNeeded()
        try resources.forEach {
            let url = outputURL.appendingPathComponent($0.filename)
            let directory = url.deletingLastPathComponent()
            try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)

            try $0.contents.write(to: url, atomically: true, encoding: .utf8)
        }
    }
    
    func createOutputFolderIfNeeded() throws {
        try FileManager.default.createDirectory(at: outputURL, withIntermediateDirectories: true)
    }
}
