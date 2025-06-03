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
        
//        measure(noteList.outputFolder) { [weak self] in
            
//            guard let self else { return }
            
            try self.core.getNoteLists(noteList).forEach { holder in
                
//                let hash = holder.hash()
//                let slug = "\(noteList.outputFolder)-\(holder.slug))"
                
                /// Check if file has changed from cache, otherwise override
//                guard self.store.state().noteListCache[slug] != hash else { return }
                
                try self.writeToFile(
                    contents: holder.html.render(),
                    outputPath: "/standalone/\(noteList.outputFolder)/\(holder.slug)",
                    filename: "index.html"
                )
                
                /// Update cache
//                try self.store.update(.noteListCache(slug: slug, hash: hash))
                            
            #if DEBUG
                print("Standalone \(noteList.outputFolder) note list \(holder.slug)")
            #endif
            }
//        }
    }
}
