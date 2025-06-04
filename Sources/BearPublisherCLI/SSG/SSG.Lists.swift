//
//  File.swift
//  
//
//  Created by Cristian Felipe Patiño Rojas on 09/09/2023.
//

import Foundation

extension SSG {
     
     func writeLists() {
         let group = DispatchGroup()
         let queue = DispatchQueue(label: "lists", attributes: .concurrent)
         
         let writes = [
            writeBacklinksNoteLists,
            writeDefaultMenuNoteLists,
            wirteTagsNoteLists
         ]
         
         measure("Standalone") { 
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
    
    func writeBacklinksNoteLists() throws {
        try writeNoteList(.backlinks)
    }
    
    func writeDefaultMenuNoteLists() throws {
        try writeNoteList(.defaultFilter)
    }
    
    func wirteTagsNoteLists() throws {
        try writeNoteList(.tags)
    }
    
    private func writeNoteList(_ noteList: Core.NoteLists) throws {
        
            try self.core.getNoteLists(noteList).forEach { holder in
                /// Check if file has changed from cache, otherwise override
                
                try self.writeToFile(
                    contents: holder.html.render(),
                    outputPath: "/standalone/\(noteList.outputFolder)/\(holder.slug)",
                    filename: "index.html"
                )
            }
    }
}
