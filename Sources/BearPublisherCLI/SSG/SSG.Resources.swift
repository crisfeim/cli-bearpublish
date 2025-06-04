//
//  File.swift
//  
//
//  Created by Cristian Felipe Patiño Rojas on 09/09/2023.
//

import Foundation
import BearPublisherWeb

extension SSG {
    
    func generateHash() -> String {
        String(UUID().uuidString.prefix(10))
    }
    
    func writeResources() {
    
        let group = DispatchGroup()
        let queue = DispatchQueue(label: "resources", attributes: .concurrent)
        
        measure("CSS/JS") { [weak self] in
            guard let self else { return }
            let writes = [
                self.writeCSS,
                self.writeJS,
                self.writeImageFolder,
                self.writeFileFolder
            ]
            
            writes.forEach { write in
                group.enter()
                queue.async {
                    defer { group.leave() }
                    try? write()
                }
            }
            
            group.wait()
        }
    }
   
    // MARK: - Write
    func writeCSS() throws {
        
        let css = BaseLayout.makeCSS() + StandaloneNote.makeCSS()
        try css.forEach { resource in
            try writeToFile(
                contents: resource.content,
                outputPath: "assets/css",
                filename: resource.fileName)
        }
    }

    func writeJS() throws {
        
        let group = DispatchGroup()
        let queue = DispatchQueue(label: "js", attributes: .concurrent)
        
        let js = BaseLayout.makeJS()
        (js.head + js.body).forEach { resource in
            group.enter()
            queue.async { [weak self] in
                defer { group.leave() }
                guard let self else { return }
                try? self.writeToFile(
                    contents: resource.content,
                    outputPath: "assets/js",
                    filename: resource.fileName)
            }
        }

        group.wait()
    }
    
    func writeImageFolder() {
        let outputFolder = outputURL.appendingPathComponent("images").relativePath
        let script = """
        cp -r \"\(imageFolder)\" \"\(outputFolder)\"
        """
        let output = shell(script)
        print(output)
    }
    
    func writeFileFolder() {
        let outputFolder = outputURL.appendingPathComponent("files").relativePath
        let script = """
        cp -r \"\(filesFolder)\" \"\(outputFolder)\"
        """
        let output = shell(script)
        print(output)
    }
}
