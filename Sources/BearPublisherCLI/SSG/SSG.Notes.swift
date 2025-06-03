//
//  File.swift
//  
//
//  Created by Cristian Felipe Patiño Rojas on 25/10/2023.
//
import BearPublisherWeb
import Foundation

extension SSG {
    
    func writeNotes() throws {
        
        let group = DispatchGroup()
        let queue = DispatchQueue(label: "lat.cristian.notes-queue", attributes: .concurrent)
        
        core.allDbNotes.forEach { note in
            
            group.enter()
            queue.async { [weak self] in

                guard let self else { return }

                defer { group.leave() }
                
                let slug = slugify(note.title ?? "")
                let model =  note.toMainModel(parse: self.core.parse(id:content:))
                
                let html = StandaloneNote(
                    title: model.title,
                    slug: model.slug,
                    content: model.content
                )
                .body
                
                try? self.writeToFile(
                    contents: html.render(),
                    outputPath: "standalone/note/\(slug)",
                    filename: "index.html"
                )
            }
        }
        
        group.wait()
    }
    
}
