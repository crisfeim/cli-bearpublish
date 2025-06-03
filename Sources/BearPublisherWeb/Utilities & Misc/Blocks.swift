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

public extension FileBlock {
    struct Data {
        public init(id: String, name: String, date: Date? = nil, `extension`: String, size: Int) {
            self.id = id
            self.name = name
            self.date = date
            self.`extension` = `extension`
            self.size = size
        }
        
        let id: String
        let name: String
        let date: Date?
        let `extension`: String
        let size: Int
        
    }
    
    struct Renderer: Component {
        public init(data: FileBlock.Data) {
            self.data = data
        }
        
        let data: Data
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
        let data: Data
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
        let data: Data
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
        let data: Data
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
    
    
    // @todo: mp4 block
    //
    //
    //
    //    //    if data.extension == "mp4" || data.extension == "mov" {
    //    //       return """
    //    //        <video controls playsinline>
    //    //          <source src="/files/\(data.id)" type="video/mp4">
    //    //        </video>
    //    //       """
    //    //    }
}


//func fileblockProcessor(_ title: String) -> String {
//    guard let data = try? api.getFileData(from: title) else {
//        return "@todo: Error, handle this case"
//    }
//
////    if data.extension == "mp4" || data.extension == "mov" {
////       return """
////        <video controls playsinline>
////          <source src="/files/\(data.id)" type="video/mp4">
////        </video>
////       """
////    }
//
//    if data.extension == "html" {
//        return """
//        <div class="iframe">
//        <iframe width="100%" height="400px" src="/files/\(data.id)"></iframe>
//                    <a class="file-block" href="/files/\(data.id)">
//                        <span class="filename">\(data.name)</span>
//                        <span>
//                            <span class="extension">\(data.extension)</span>
//                            <span class="meta">
//                                    <span class="file-size">\(data.size.toFileSize())</span>·
//                                    <time>\(data.date?.dMMMyyyy() ?? "No date found")</time>
//                               </span>
//                        </span>
//                    </a>
//        </div>
//        """
//    }
//
//
//    return """
//    <a class="file-block" href="/files/\(data.id)">
//        <span class="filename">\(data.name)</span>
//        <span>
//            <span class="extension">\(data.extension)</span>
//            <span class="meta"><span class="file-size">\(data.size.toFileSize())</span>·<time>\(data.date?.dMMMyyyy() ?? "No date found")</time></span>
//        </span>
//    </a>
//    """
//}



import Foundation
// @todo: move to a pertinent place
extension Int {
    func toFileSize() -> String {
        let formatter = ByteCountFormatter()
        formatter.allowedUnits = [.useBytes, .useKB, .useMB, .useGB]
        formatter.countStyle = .file
        
        return formatter.string(fromByteCount: Int64(self))
    }
}
