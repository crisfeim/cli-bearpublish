//
//  SwiftUIView.swift
//  
//
//  Created by Cristian Felipe Patiño Rojas on 02/09/2023.
//

import Plot

// MARK: - HTMX, Hyperscript and other extensions
extension Component {
    func tabIndex(_ value: Int) -> Component {
        attribute(named: "tabindex", value: value.description)
    }
    
    func hyperscript(_ script: String) -> Component {
        attribute(named: "_", value: script)
    }
}

extension Node<HTML.BodyContext> {
    static func makeCheckbox(_ sidebarName: String) -> Node<HTML.BodyContext> {
        .input(
            .id("\(sidebarName)-checkbox"),
            .name("\(sidebarName)-checkbox"),
            .attribute(named: "type", value: "checkbox"),
            .attribute(named: "style", value: "display:none"),
            .class("\(sidebarName)-checkbox")
        )
    }
    
    static func menu(_ nodes: Self...) -> Self {
        .element(named: "menu", nodes: nodes)
    }
}


