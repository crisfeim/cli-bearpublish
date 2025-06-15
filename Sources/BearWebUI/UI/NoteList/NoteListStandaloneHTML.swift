//
//  File.swift
//  
//
//  Created by Cristian Felipe Patiño Rojas on 24/10/2023.
//

import Plot

public struct NoteListStandaloneHTML: HTMLDocument {
    private let title: String
    private let notes: [NoteViewModel]
    
    public init(title: String, notes: [NoteViewModel]) {
        self.title = title
        self.notes = notes
    }
    
    public var body: HTML {
        HTML(.body(.component(NoteListHTML(title: title, notes: notes))))
    }
}


