//
//  File.swift
//  
//
//  Created by Cristian Felipe Patiño Rojas on 08/09/2023.
//

import Foundation

public enum SVG: String, Equatable {
    case burger
    case chevron
    case note
    case pin
    case searchglass
    case share
    case tag
    case threedots
    case checkbox
    case archive
    case lock
    case bin
    
    public func render() -> String {
        getSVGFile(self.rawValue)
    }
    
    struct Defaults {
        let width: Int
        let height: Int
        let fill: String
        let stroke: String
    }
    
    var defaults: Defaults {
        switch self {
        case .note: return .init(width: 18, height: 18, fill: "", stroke: "")
        default: return .init(width: 12, height: 12, fill: "black", stroke: "black")
        }
    }
    
}

import Plot

struct SVGRenderer: Component {
    let svg: SVG
    fileprivate(set) var width: Int?
    fileprivate(set) var height: Int?
    fileprivate(set) var fill: String?
    fileprivate(set) var stroke: String?
    fileprivate(set) var cssClass: String?
    
    
    init(_ svg: SVG) { self.svg = svg }
    
    var body: Component {
        svg.render()
            .replacingOccurrences(of: "${width}", with: (width ?? svg.defaults.width).description)
            .replacingOccurrences(of: "${height}", with: (height ?? svg.defaults.height).description)
            .replacingOccurrences(of: "${fill}", with: (fill ?? svg.defaults.fill))
            .replacingOccurrences(of: "${stroke}", with: (stroke ?? svg.defaults.stroke))
            .replacingOccurrences(of: "${cssClass}", with: (cssClass ?? ""))
            .makeRawNode()
    }
    
    
    func width(_ value: Int) -> Self {
        var copy = self
        copy.width = value
        return copy
    }
    
    func height(_ value: Int) -> Self {
        var copy = self
        copy.height = height
        return copy
    }

    func fill(_ value: String) -> Self {
        var copy = self
        copy.fill = value
        return copy
    }

    func stroke(_ value: String) -> Self {
        var copy = self
        copy.stroke = stroke
        return copy
    }

    func cssClass(_ value: String) -> Self {
        var copy = self
        copy.cssClass = value
        return copy
    }
}

enum MenuIcons {
    case pin
    case regular
    
    var svg: String {
        switch self {
        case .regular: return """
            <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none">
            <path opacity="0.4" d="M4.17038 15.2998L8.70038 19.8298C10.5604 21.6898 13.5804 21.6898 15.4504 19.8298L19.8404 15.4398C21.7004 13.5798 21.7004 10.5598 19.8404 8.6898L15.3004 4.1698C14.3504 3.2198 13.0404 2.7098 11.7004 2.7798L6.70038 3.0198C4.70038 3.1098 3.11038 4.6998 3.01038 6.6898L2.77038 11.6898C2.71038 13.0398 3.22038 14.3498 4.17038 15.2998Z"/>
            <path d="M9.49914 12.3801C11.0897 12.3801 12.3791 11.0907 12.3791 9.50012C12.3791 7.90954 11.0897 6.62012 9.49914 6.62012C7.90856 6.62012 6.61914 7.90954 6.61914 9.50012C6.61914 11.0907 7.90856 12.3801 9.49914 12.3801Z"/>
            </svg>
            """
        case .pin:
            let strokeWidth = "1.5"
            return """
            <svg class="pin" xmlns="http://www.w3.org/2000/svg" width="7.667" height="12.789" viewBox="0 0 8.667 13.789">
              <g id="Grupo_1" data-name="Grupo 1" transform="translate(-28.25 -107)">
                <g id="Elipse_3" data-name="Elipse 3" transform="translate(29 107)" fill="none" stroke-width="\(strokeWidth)">
                  <circle cx="3.5" cy="3.5" r="3.5" stroke="none"/>
                  <circle cx="3.5" cy="3.5" r="3" fill="none"/>
                </g>
                <path id="Trazado_1" data-name="Trazado 1" d="M0,0V6.515" transform="translate(32.583 113.356)" fill="none" stroke-width="\(strokeWidth)"/>
                <line id="Línea_7" data-name="Línea 7" x2="8.667" transform="translate(28.25 120.289)" fill="none" stroke-width="\(strokeWidth)"/>
              </g>
            </svg>
            """
        }
    }
}
