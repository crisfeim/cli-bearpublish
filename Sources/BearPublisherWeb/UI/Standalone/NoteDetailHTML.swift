//
//  File.swift
//  
//
//  Created by Cristian Felipe Patiño Rojas on 24/10/2023.
//

import Plot

/// Standalone note component. It contains only the content of the note without the additional three panel layouts.
/// This is used to generate the standalone pages that will be consummed by HTMX when user selects a note thorugh the <nav> (note list) component.
public struct NoteDetailHTML: HTMLDocument {
    
    fileprivate let title: String
    fileprivate let content: String
    fileprivate let slug: String
    
    fileprivate var css: [Resource] { Self.makeCSS() }
    
    public init(
        title: String,
        slug: String,
        content: String
    ) {
        self.title = title
        self.slug = slug
        self.content = content
    }
    
    public var body: HTML {
        HTML(
            .style("overflow: scroll"),
            .lang(.spanish),
            .head(
                .title(title),
                .forEach(css, {.stylesheet($0.fullPath)})
            ),
            .body(
                .class("js-off"),
                .div(.component(Main(content: content)))
            )
        )
    }
}

public extension NoteDetailHTML {
    
    static func makeCSS() -> [Resource] {
        
        let vars  = getCSSFile("theme-variables")
        let bear  = getCSSFile("bear")
        let main  = getCSSFile("main")
        
        let theme      = Resource(name: "theme-variables", fileExtension: "css", content: vars       )
        let standalone = Resource(name: "standalone"     , fileExtension: "css", content: bear + main)
        
        return [theme, standalone]
    }
}
