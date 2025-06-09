//
//  File.swift
//  
//
//  Created by Cristian Felipe Patiño Rojas on 24/10/2023.
//

import Plot
import BearPublisherDomain

/// Standalone nav (note list). This will be used to generate the standalone note list that will be consumed through HTMX when switching tags, or default notes filter on <menu> component
public struct NoteListView: View {
    let title: String
    let notes: [Note]
    
    public init(title: String, notes: [Note]) {
        self.title = title
        self.notes = notes
    }
    
    public var body: HTML {
        HTML(.body(.component(list)))
    }
}

extension NoteListView {
    @ComponentBuilder
    public var list: Component {
        Header {
            Label("") {
                SVG.burger
                    .render()
                    .makeRawNode()
            }
            .id("menu-toggle")
            .class("js-element")
            .attribute(named: "for", value: "menu-checkbox")
            Spacer()
            H4(title).class("title")
            Spacer()
        }
        
        List {}
            .id("spinner")
            .class("htmx-indicator")
        
        List(notes) { item in
            Cell(note: item, isSelected: false)
        }
        .id("note-list")
    }
}
