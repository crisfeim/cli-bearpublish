//
//  File.swift
//  
//
//  Created by Cristian Felipe Patiño Rojas on 08/09/2023.
//

import Plot
import BearPublisherDomain

extension Menu {
    public struct Cell: Component {
        let tag: Tag
        let isSelected: Bool
       
        /// This class is used as a unique hash which allows to scroll to the target tag when
        /// user clicks on a hashtag inside a note
        var detailsClass: String {
            let _isSelected = isSelected ? "selected-menu-item": ""
            let isSelected = _isSelected.isEmpty ? "" : " " + _isSelected
            let safeHash = tag.fullPath.replacingOccurrences(
                of: "&",
                with: "/"
            ).safeHash
            return safeHash + isSelected
        }
       
        
        public var body: Component { js }
        
        fileprivate var js: Component {
            Div {
                HStack {
//                    SVGRenderer(model.icon)
//                        .cssClass(model.isSelected ? "selected-svg" : "")
                        
                    Span(tag.name)
                    Spacer()
                    if tag.isPinned {
                        MenuIcons.pin.svg.makeRawNode()
                    }
                    
                    Div {
                        SVG.chevron.render().makeRawNode()
                    }
                    .class("chevron \(isSelected ? "selected-chevron" : "")")
                    .hyperScript(tag.children.isEmpty ? "" : "on click halt the event then toggle .opened-child on the closest .menu-item then toggle .rotate45 on me")
                    .style("display: flex; \(tag.children.isEmpty ? "opacity: 0" : "opacity: 1")")
                }
                .class("content")
                .spacing(.xs)
                .hxGet("/standalone\(tag.path)")
                .hxTarget("nav")
                .hxIndicator(.id("spinner"))
                .hxPushUrl(tag.makePath())
                .hxSwap("innerHTML scroll:top")
                .data(named: "count", value: tag.notesCount.description)
                .hyperScript(hyperscript)
                
                if !tag.children.isEmpty {
                    Div {
                        for children in tag.children {
                            Cell(tag: children, isSelected: false)
                        }
                    }
                    .class("childs")
                    .style("padding-left: 12px")
                }
            }
            .class("menu-item \(detailsClass)")
            .hyperScript(menuItemScript)
        }
        
        let hyperscript = """
        on click remove .selected-menu-item from .selected-menu-item then add .selected-menu-item to my.parentElement then Layout.toggleMenu()
        """
        
        let menuItemScript = """
        on mutation of @class if I match .selected-menu-item remove .selected-svg from .selected-svg then add .selected-svg to the first <svg/> in me
        then remove .selected-chevron from .selected-chevron then add .selected-chevron to the first .chevron in me
        """
        
//        let detailsScript = """
//        on mutation of @class if I match .selected-menu-item remove .selected-summary from .selected-summary then add .selected-summary to the first <summary/> in me
//        """
        
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

