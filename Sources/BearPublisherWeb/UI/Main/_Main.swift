//
//  File.swift
//  
//
//  Created by Cristian Felipe Patiño Rojas on 08/09/2023.
//

import Plot

public struct Main: Component {
    
    private let content: String?
    
    public init(content: String? = nil) {
        self.content = content
    }
    
    @ComponentBuilder
    public var body: Component {
        Header {
            Label("") {
                SVG.chevron.render().makeRawNode()
            }
            .id("nav-toggle")
            .attribute(named: "for", value: "nav-checkbox")
            .hyperScript("on click set #menu-checkbox.checked to false")
            .class("js-element")
            
            Span {
                Link(
                    "title @todo",
                    url: "bear://x-callback-url/open-note?title=@todo"
                )
            }
            .style("display:none") // @todo
            
//            threedots // @todo
        }
        
        Article {
            NoteDetailSkeleton()
            if let content = content {
                Div {
                    Raw(text: content)
                }
                .class("content \(Indicators.mainIndicator)")
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
        .attribute(named: "spacing", value: "xs") // @todo
    }
}

struct NoteDetailSkeleton: Component {
    
    var body: Component {
        Div {
            Div {}.class("title-placeholder")
            Div {}.class("text-placeholder")
            Div {}.class("text-placeholder")
            Div {}.class("text-placeholder")
            Div {}.class("text-placeholder")
            Div {}.class("text-placeholder")
            Div {}.class("text-placeholder")
        }
        .class("skeleton \(Indicators.mainIndicator)")
        .style("padding-top: 24px")
    }
}
