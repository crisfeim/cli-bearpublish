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
    let spaModeEnabled: Bool
    
    public init(title: String, model: [NoteList.Model], spaModeEnabled: Bool) {
        self.title = title
        self.model = model
        self.spaModeEnabled = spaModeEnabled
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
            Row(note: item, spaModeEnabled: spaModeEnabled)
        }
        .id("note-list")
    }
    
}
