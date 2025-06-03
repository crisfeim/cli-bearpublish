//
//  File.swift
//  
//
//  Created by Cristian Felipe Patiño Rojas on 24/10/2023.
//

import Plot

/// Standalone nav (note list). This will be used to generate the standalone note list that will be consumed through HTMX when switching tags, or default notes filter on <menu> component
public struct StandaloneNoteList {
    let title: String
    let notes: [NoteList.Model]
    
    public init(title: String, notes: [NoteList.Model]) {
        self.title = title
        self.notes = notes
    }
    
    public var body: HTML {
        HTML(.body(.component(NoteList(title: title, model: notes))))
    }
}
