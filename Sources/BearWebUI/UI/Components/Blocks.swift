//
//  File.swift
//  
//
//  Created by Cristian Felipe Patiño Rojas on 08/09/2023.
//

import Plot

public enum FileBlock {}

public extension FileBlock {
     enum Extension {
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
}

public struct FileUI {
    public let id: String
    public let name: String
    public let date: Date?
    public let `extension`: String
    public let size: Int
    
    public init(id: String, name: String, date: Date? = nil, `extension`: String, size: Int) {
        self.id = id
        self.name = name
        self.date = date
        self.`extension` = `extension`
        self.size = size
    }
}

public extension FileBlock {
    struct Renderer: Component {
        public init(data: FileUI) {
            self.data = data
        }
        
        let data: FileUI
        private var `extension`: Extension { .init(value: data.extension) }
        
        @ComponentBuilder
        public var body: Component {
            switch `extension` {
            case .html: HTML(data: data)
            case .mp4, .mov: Video(data: data)
            default: Description(data: data)
            }
        }
    }
}

fileprivate extension FileBlock {
    
    struct HTML: Component {
        let data: FileUI
        var body: Component {
            Div {
                IFrame(url: "/files/\(data.id)/\(data.name)", addBorder: false, allowFullScreen: false, enabledFeatureNames: [])
                    .attribute(named: "width", value: "100%")
                    .attribute(named: "height", value: "400px")
                
                Description(data: data)
            }
            .class("iframe")
        }
    }
    
    struct Description: Component {
        let data: FileUI
        var body: Component {
            
            Link(url: "/files/\(data.id)/\(data.name)") {
                Span(html: data.name).class("filename")
                Span {
                    Span(html: data.extension).class("extension")
                    Span {
                        Span(html: data.size.toFileSize()).class("file-size")
                        Time(datetime: data.date?.dMMMyyyy()) { Text(data.date?.dMMMyyyy()  ?? "No date found") }
                    }
                    .class("meta")
                }
            }
            .class("file-block")
        }
    }
    
    struct Video: Component {
        let data: FileUI
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
