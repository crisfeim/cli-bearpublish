//
//  File.swift
//  
//
//  Created by Cristian Felipe Patiño Rojas on 24/10/2023.
//

import Plot
import BearPublisherDomain

public struct NoteListHTML: HTMLDocument {
    let title: String
    let notes: [Note]
    
    public init(title: String, notes: [Note]) {
        self.title = title
        self.notes = notes
    }
    
    public var body: HTML {
        HTML(.body(.component(NoteList(title: title, notes: notes))))
    }
}


