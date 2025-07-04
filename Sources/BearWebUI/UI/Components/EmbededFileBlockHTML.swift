//
//  File.swift
//  
//
//  Created by Cristian Felipe Patiño Rojas on 08/09/2023.
//

import Plot

public struct EmbededFileBlockHTML: Component {
    private let data: FileViewModel
    private var ext: Ext { .init(value: data.ext) }
    
    public init(data: FileViewModel) {
        self.data = data
    }
    
    @ComponentBuilder
    public var body: Component {
        switch ext {
        case .html: HtmlBlock(data: data)
        case .mp4, .mov: VideoBlock(data: data)
        default: DescriptionBlock(data: data)
        }
    }
}

fileprivate extension EmbededFileBlockHTML {
    enum Ext {
        case html
        case mp4
        case mov
        case other

        public init(value: String) {
            switch value {
            case "html": self = .html
            case "mp4": self = .mp4
            case "mov": self = .mov
            default: self = .other
            }
        }
    }

    struct HtmlBlock: Component {
        let data: FileViewModel
        var body: Component {
            Div {
                IFrame(url: "/files/\(data.id)/\(data.name)", addBorder: false, allowFullScreen: false, enabledFeatureNames: [])
                    .attribute(named: "width", value: "100%")
                    .attribute(named: "height", value: "400px")
                
                DescriptionBlock(data: data)
            }
            .class("iframe")
        }
    }
    
    struct DescriptionBlock: Component {
        let data: FileViewModel
        var body: Component {
            
            Link(url: "/files/\(data.id)/\(data.name)") {
                Span(html: data.name).class("filename")
                Span {
                    Span(html: data.ext).class("extension")
                    Span {
                        Span(html: data.size.toFileSize()).class("file-size")
                        Time(datetime: data.creationDate) { Text(data.creationDate) }
                    }
                    .class("meta")
                }
            }
            .class("file-block")
        }
    }
    
    struct VideoBlock: Component {
        let data: FileViewModel
        var body: Component {
            Element(name: "video") {
                Element(name: "source") {}
                    .attribute(named: "src", value: "/files/\(data.id)/\(data.name)")
                    .attribute(named: "type", value: "video/mp4")
            }
            .attribute(named: "controls", value: "true")
            .attribute(named: "playsinline", value: "true")
        }
    }
}



import Foundation
extension Int {
    func toFileSize() -> String {
        let formatter = ByteCountFormatter()
        formatter.allowedUnits = [.useBytes, .useKB, .useMB, .useGB]
        formatter.countStyle = .file
        
        return formatter.string(fromByteCount: Int64(self))
    }
}
