//
//  File.swift
//  
//
//  Created by Cristian Felipe Patiño Rojas on 24/10/2023.
//

import Plot

public struct NoteStandaloneHTML: HTMLDocument {
    
    private let title: String
    private let content: String
    private let slug: String
    
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
            .head(.title(title)),
            .body(
                .class("js-off"),
                .div(.component(NoteHTML(content: content)))
            )
        )
    }
}
