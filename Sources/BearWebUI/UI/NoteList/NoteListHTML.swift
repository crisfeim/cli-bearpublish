// © 2025  Cristian Felipe Patiño Rojas. Created on 9/6/25.


import Plot

struct NoteListHTML: Component {
    let title: String
    let notes: [NoteViewModel]
    
    @ComponentBuilder
    var body: Component {
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
        
        List(notes, content: Cell.init)
            .id("note-list")
    }
}
