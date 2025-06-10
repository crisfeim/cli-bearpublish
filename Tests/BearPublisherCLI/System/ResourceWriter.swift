// © 2025  Cristian Felipe Patiño Rojas. Created on 4/6/25.


import Foundation

struct ResourceWriter {
    let resources: [Resource]
    let outputURL: URL
    
    func build() throws {
        cleanOutputFolder()
        try createOutputFolder()
        try resources.forEach {
            let url = outputURL.appendingPathComponent($0.filename)
            let directory = url.deletingLastPathComponent()
            try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)

            try $0.contents.write(to: url, atomically: true, encoding: .utf8)
        }
    }
    
    private func cleanOutputFolder() {
        try? FileManager.default.removeItem(at: outputURL)
    }
    
    
    private func createOutputFolder() throws {
        try FileManager.default.createDirectory(at: outputURL, withIntermediateDirectories: true)
    }
}
