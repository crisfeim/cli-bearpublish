//
//  File.swift
//  
//
//  Created by Cristian Felipe Patiño Rojas on 24/10/2023.
//

import Plot

public struct NoteDetailHTML: HTMLDocument {
    
    private let title: String
    private let content: String
    private let slug: String
    
    private var css: [Resource] { Self.makeCSS() }
    
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

private extension NoteDetailHTML {
    
    static func makeCSS() -> [Resource] {
        
        let vars  = getCSSFile("theme-variables")
        let bear  = getCSSFile("bear")
        let main  = getCSSFile("main")
        
        let theme      = Resource(name: "theme-variables", fileExtension: "css", content: vars       )
        let standalone = Resource(name: "standalone"     , fileExtension: "css", content: bear + main)
        
        return [theme, standalone]
    }
}
