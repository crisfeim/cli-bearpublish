//
//  NoteList.swift
//  
//
//  Created by Cristian Felipe Patiño Rojas on 06/09/2023.
//
import Foundation
import Plot

public struct NoteList: Component {
    
    let title: String
    let model: [NoteList.Model]
    
    public init(title: String, model: [NoteList.Model]) {
        self.title = title
        self.model = model
    }
    
    @ComponentBuilder
    public var body: Component {
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
        
        List(model) { item in
            Row(note: item)
        }
        .id("note-list")
    }
    
}
