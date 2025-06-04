//
//  File.swift
//  
//
//  Created by Cristian Felipe Patiño Rojas on 08/09/2023.
//

import Plot

extension NoteList {
    struct Row: Component {
        let note: NoteList.Model
        #warning("Tab index should be different if selected")
        var tabindex: Int { note.isSelected ? 0 : 0}
        
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
                .class(note.isSelected ? "selected" : "")
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
