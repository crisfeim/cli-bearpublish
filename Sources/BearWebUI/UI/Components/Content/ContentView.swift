//
//  File.swift
//  
//
//  Created by Cristian Felipe Patiño Rojas on 08/09/2023.
//

import Plot

struct ContentView: Component {
    let content: String?
   
    @ComponentBuilder
    var body: Component {
        Header {
            Label("") {
                SVG.chevron.render().makeRawNode()
            }
            .id("nav-toggle")
            .attribute(named: "for", value: "nav-checkbox")
            .hyperscript("on click set #menu-checkbox.checked to false")
            .class("js-element")
        }
        
        Article {
            Skeleton()
            
            if let content = content {
                Div { Raw(text: content) }
                .class("content main-indicator")
            }
        }
        .class("document-wrapper")
    }
    
    var threedots: Component {
        HStack {
            Div {
                SVG.threedots.render().makeRawNode()
            }
            .id("share-button")
            .class("js-element")
        }
        .attribute(named: "spacing", value: "xs")
    }
}


