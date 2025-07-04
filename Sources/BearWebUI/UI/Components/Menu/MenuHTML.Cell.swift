//
//  File.swift
//
//
//  Created by Cristian Felipe Patiño Rojas on 08/09/2023.
//

import Plot

extension MenuHTML {
    struct Cell: Component {
        let icon: SVG
        let item: MenuItemViewModel
        let getRouter: (String) -> String
        let pushedURL: (String) -> String
        
        /// This class is used as a unique hash which allows to scroll to the target tag when
        /// user clicks on a hashtag inside a note
        var detailsClass: String {
            let safeHash = item.fullPath.replacingOccurrences(
                of: "&",
                with: "/"
            ).safeHash
            return safeHash
        }
        
        
        var body: Component {
            Div {
                HStack {
                    SVGRenderer(icon)
                    
                    Span(item.name)
                    Spacer()
                    
                    Div {
                        SVG.chevron.render().makeRawNode()
                    }
                    .class("chevron")
                    .hyperscript(item.children.isEmpty ? "" : "on click halt the event then toggle .opened-child on the closest .menu-item then toggle .rotate45 on me")
                    .style("display: flex; \(item.children.isEmpty ? "opacity: 0" : "opacity: 1")")
                }
                .class("content")
                .spacing(.xs)
                .hx_get(getRouter(item.fullPath))
                .hx_target("nav")
                .hx_indicator(.id("spinner"))
                .hx_push_url(pushedURL(item.fullPath))
                .hx_swap("innerHTML scroll:top")
                .data(named: "count", value: item.notesCount.description)
                .hyperscript(hyperscript)
                
                if !item.children.isEmpty {
                    Div {
                        for children in item.children {
                            Cell(
                                icon: children.icon,
                                item: children,
                                getRouter: getRouter,
                                pushedURL: pushedURL
                            )
                        }
                    }
                    .class("childs")
                    .style("padding-left: 12px")
                }
            }
            .class("menu-item \(detailsClass)")
            .hyperscript(menuItemScript)
        }
        
        let hyperscript = """
        on click remove .selected-menu-item from .selected-menu-item then add .selected-menu-item to my.parentElement then Layout.toggleMenu()
        """
        
        let menuItemScript = """
        on mutation of @class if I match .selected-menu-item remove .selected-svg from .selected-svg then add .selected-svg to the first <svg/> in me
        then remove .selected-chevron from .selected-chevron then add .selected-chevron to the first .chevron in me
        """
        
        let linkScript = """
        on click remove .selected-menu-item from .selected-menu-item then add .selected-menu-item to the closest <details/>
        then Layout.toggleMenu()
        """
        
        fileprivate var rowScript: String {
            """
            on click remove .selected-menu-item from .selected-menu-item then add .selected-menu-item to the closest <details/>
            then remove .selected-summary from .selected-summary then add .selected-summary to the closest <summary/>
            then Layout.toggleMenu()
            """
        }
    }
}

