//
//  File.swift
//  
//
//  Created by Cristian Felipe Patiño Rojas on 25/10/2023.
//

extension SSG {
    func writeIndex() throws {
        let index = core
            .getIndex()
            .body
        
        let indexUrl = outputURL.appendingPathComponent("index.html", isDirectory: false)
        try index.render().write(to: indexUrl, atomically: true, encoding: .utf8)
    }
}
