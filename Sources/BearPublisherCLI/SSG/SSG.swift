//
//  File.swift
//  
//
//  Created by Cristian Felipe Patiño Rojas on 08/09/2023.
//

import Foundation
import BearPublisherWeb

let imageFolder = "/Users/\(NSUserName())/Library/Group Containers/9K33E3U3T4.net.shinyfrog.bear/Application Data/Local Files/Note Images"
let filesFolder = "/Users/\(NSUserName())/Library/Group Containers/9K33E3U3T4.net.shinyfrog.bear/Application Data/Local Files/Note Files"

enum Constants {
    static let urlScheme = "file://"
    static let outputFolder = "/Users/\(NSUserName())/dev/serve/notas.cristian/"
    
    static var outputURL: URL { URL(string: urlScheme + outputFolder)! }
}


public final class SSG {
   
    let core: Core
    fileprivate(set) var outputURL: URL?
    
    public init(core: Core) {
        self.core = core
    }
    
    
    /// Builds site.
    /// - Parameters:
    ///   - destinationURL: The output url where the site will be generated.
    ///   - completion: Block that will be execute once the site generatiion ends. Will run on main thread.
    public func build(on destinationURL: URL, completion: @escaping () -> Void) throws {
        self.outputURL = destinationURL
        
        let group = DispatchGroup()
        let queue = DispatchQueue(label: "build", attributes: .concurrent)
        measure("Building") { [weak self] in
            guard let self else { return }
            
            let writes = [
                self.writeResources,
                self.writeIndex,
                self.writeLists,
                self.writeNotes
            ]
            writes.forEach { write in
                group.enter()
                queue.async {
                    defer { group.leave() }
                    try? write()
                }
            }
            group.wait()
            self.core.api.close()
        }
        
        group.notify(queue: .main) {
            completion()
        }
    }
}


public enum SSGError: Error {
    case unsettedOutputFolder
    case failedTryingToInitCore
}

// MARK: - Helpers
extension SSG {
    
    func measure(_ value: String, _ completion: @escaping () throws -> Void) {
        print("############# \(value) #############")
        let startTime = Date()
        print("Start \(value) at:\(startTime)")
        try? completion()
        let endTime = Date()
        let elapsedTime = endTime.timeIntervalSince(startTime)
        print("Finished \(value) at, \(endTime), \(elapsedTime)")
    }

    /// Writes file to output path only if there has been a change to the file
    func writeToFile(contents: String, outputPath: String, filename: String) throws {
        guard let outputURL else { throw SSGError.unsettedOutputFolder }
        let outputDirectoryURL = outputURL
            .appendingPathComponent(outputPath)
        let outputFileURL = outputDirectoryURL
            .appendingPathComponent(filename)
        
        try FileManager.default.createDirectory(
            at: outputDirectoryURL,
            withIntermediateDirectories: true,
            attributes: nil
        )
        
        try contents.write(
            to: outputFileURL,
            atomically: true,
            encoding: .utf8
        )
    }
}

func shell(_ command: String) -> String {
    let process = Process()
    let pipe = Pipe()
    process.standardOutput = pipe
    process.standardError = pipe
    process.arguments = ["-c", command]
    process.launchPath = "/bin/bash"
    process.launch()
    let data = pipe.fileHandleForReading.readDataToEndOfFile()
    let output = String(data: data, encoding: .utf8)!
    return output
}

