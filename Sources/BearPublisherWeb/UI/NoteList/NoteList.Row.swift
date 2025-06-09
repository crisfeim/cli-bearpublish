//
//  File.swift
//  
//
//  Created by Cristian Felipe Patiño Rojas on 08/09/2023.
//

import Plot
import BearPublisherDomain

extension NoteListView {
    struct Row: Component {
        let note: Note
        let isSelected: Bool
        var tabindex: Int { isSelected ? 1 : 0}
        
        var pushedUrl: String {
             "/?slug=\(note.slug)"
        }
        
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
                .hxGet("/standalone/note/\(note.slug)")
                .hxTarget("main")
                .hxPushUrl(pushedUrl)
                .hxSwap("innerHTML scroll:top")
                .hxIndicator(.class(Indicators.mainIndicator))
                .hyperScript("on click take .selected then Layout.toggleNav()")
                .tabIndex(tabindex)
                .class(isSelected ? "selected" : "")
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

struct Indicators {
    private init() {}
    static let mainIndicator = "main-indicator"
    static let spinner = "spinner"
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
