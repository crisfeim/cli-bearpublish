//
//  File.swift
//  
//
//  Created by Cristian Felipe Patiño Rojas on 08/09/2023.
//

import Plot

extension NoteListView {
    struct Cell: Component {
        let note: NoteUI
        var pushedUrl: String { "/?slug=\(note.slug)" }
        
        var body: Component {
            ListItem {
                Link(url: pushedUrl) {
                    VStack {
                        H4(note.title)
                            .class("title")
                        
                        if note.isEncrypted {
                            EncryptedPlaceholder()
                        }  else {
                            Paragraph(note.subtitle)
                                .class("subtitle")
                        }
                        
                        HStack {
                            if note.isPinned {
                                SVG.pin.render().makeRawNode()
                            }
                            
                            Time(datetime: "") {
                                note.dateTime.makeRawNode()
                            }
                        }
                        .attribute(named: "spacing", value: "xs")
                        .style("padding-top: 16px")
                    }
                }
                .hx_get("/standalone/note/\(note.slug).html")
                .hx_target("main")
                .hx_push_url(pushedUrl)
                .hx_swap("innerHTML scroll:top")
                .hx_indicator(.class("main-indicator"))
                .hyperscript("on click take .selected then Layout.toggleNav()")
            }
        }
    }
}

enum Indicator {
    case `class`(String)
    case id(String)
    
    var value: String {
        switch self {
        case .class(let value): return ".\(value)"
        case .id(let value): return "#\(value)"
        }
    }
}

extension NoteListView {
    struct EncryptedPlaceholder: Component {
        var body: Component {
            Div {
                Div().class("encrypted-placeholder")
                Div().class("encrypted-placeholder")
            }
        }
    }
}
