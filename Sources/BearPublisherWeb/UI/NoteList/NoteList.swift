//
//  NoteList.swift
//  
//
//  Created by Cristian Felipe Patiño Rojas on 06/09/2023.
//
import Foundation
import Plot

import BearPublisherDomain

public struct NoteList: Component, Equatable {
    
    let title: String
    let model: [Note]
    
    public init(title: String, model: [Note]) {
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
            Row(note: item, isSelected: false)
        }
        .id("note-list")
    }
    
}
