//
//  File.swift
//  
//
//  Created by Cristian Felipe Patiño Rojas on 08/09/2023.
//

import Plot


extension Menu {
    public struct Row: Component {
        let model: Model
       
        /// This class is used as a unique hash which allows to scroll to the target tag when
        /// user clicks on a hashtag inside a note
        var detailsClass: String {
            let _isSelected = model.isSelected ? "selected-menu-item": ""
            let isSelected = _isSelected.isEmpty ? "" : " " + _isSelected
            let safeHash = model.fullPath.replacingOccurrences(
                of: "&",
                with: "/"
            ).safeHash
            return safeHash + isSelected
        }
       
        
        public var body: Component { js }
        
        fileprivate var js: Component {
            Div {
                HStack {
                    SVGRenderer(model.icon)
                        .cssClass(model.isSelected ? "selected-svg" : "")
                        
                    Span(model.name)
                    Spacer()
                    if model.isPinned {
                        MenuIcons.pin.svg.makeRawNode()
                    }
                    
                    Div {
                        SVG.chevron.render().makeRawNode()
                    }
                    .class("chevron \(model.isSelected ? "selected-chevron" : "")")
                    .hyperScript(model.children.isEmpty ? "" : "on click halt the event then toggle .opened-child on the closest .menu-item then toggle .rotate45 on me")
                    .style("display: flex; \(model.children.isEmpty ? "opacity: 0" : "opacity: 1")")
                }
                .class("content")
                .spacing(.xs)
                .hxGet("/standalone\(model.path)")
                .hxTarget("nav")
                .hxIndicator(.id(Indicators.spinner))
                .hxPushUrl(model.makePath())
                .hxSwap("innerHTML scroll:top")
                .data(named: "count", value: model.count.description)
                .hyperScript(hyperscript)
                
                if !model.children.isEmpty {
                    Div {
                        for children in model.children {
                            Row(model: children)
                        }
                    }
                    .class("childs")
                    .style("padding-left: 12px")
                }
            }
            .class("menu-item \(detailsClass)")
            .hyperScript(menuItemScript)
        }
        
        fileprivate var nojs: Component {
            Details {
                Summary {

                    model.icon.render().makeRawNode()

                    Link(model.name, url: model.makePath())
                    Spacer()
                    if model.isPinned {
                        MenuIcons.pin.svg.makeRawNode()
                    }
                }
                .class(model.isSelected ? "selected-summary": "")

                for children in model.children {
                    Row(model: children)
                }
            }
            .class(detailsClass)
            .attribute(
                named: !model.children.isEmpty ? "" : "disabled",
                value: !model.children.isEmpty ? "" : "true"
            )
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

