// © 2025  Cristian Felipe Patiño Rojas. Created on 11/6/25.


import Foundation
import RubyGateway
import MarkdownKit

extension BearMarkdown {
    final class BearHTMLGenerator: HtmlGenerator {
        
        var _slugify: Processor?
        var imgProcessor: Processor?
        var hashtagProcessor: Processor?
        var fileBlockProcessor: Processor?
        
        var slugify: Processor {
            _slugify ?? { _ in "no slugify founded injected yet" }
        }
        
        func setImgProcessor(_ processor: @escaping Processor) {
            imgProcessor = processor
        }
        func setHashtagProcessor(_ processor: @escaping Processor) {
            hashtagProcessor = processor
        }
        
        func setBlockProcessor(_ processor: @escaping Processor) {
            fileBlockProcessor = processor
        }
        
        func setSlugify(_ processor: @escaping Processor) {
            _slugify = processor
        }
        
        func parse(_ content: String) -> String {
            // Custom pre-parsing
            let note = content
                .parseImages(imgProcessor: imgProcessor)
                .parseAndReplaceHexColors()
            
            
            let doc = ExtendedMarkdownParser.standard.parse(note)
            return generate(doc: doc)
                .parseWikilinks(slugify: slugify)
                .correctWikilinksCode()
        }
        
        func parseCode(lang: String, code: String) -> String {
            return "<pre><code>" + code + "</pre></code>"
        }
        
        func generate(block: Block, tight: Bool = false) -> String {
            switch block {
            case let .heading(n, text):
                let text  = self.generate(text: text)
                let leftIndicator = """
            <span class="heading-level">
            <a>\(n)</a>
            </span>
            """
                let open  = "<h\(n > 0 && n < 7 ? n : 1) id=\"\(slugify(text))\">"
                let close = "</h\(n)>\n"
                return "\(open)\(leftIndicator)\(text)\(close)"
            case .fencedCode(let lang, let lines):
                if let language = lang {
                    let lines = self.generate(lines: lines, separator: "").encodingPredefinedXmlEntities()
                    let parsed = parseCode(lang: language, code: lines)
                    return parsed
                } else {
                    return "<pre><code>" +
                    self.generate(lines: lines, separator: "").encodingPredefinedXmlEntities() +
                    "</code></pre>\n"
                }
            default:
                return super.generate(block: block, parent: .none, tight: tight)
            }
        }
        
        override func generate(lines: Lines, separator: String = "\n") -> String {
            let lines = super.generate(lines:  lines, separator: "")
            
            return lines.parseWikilinksCode()
        }
        
        
        override func generate(textFragment fragment: TextFragment) -> String {
            switch fragment {
            case let .text(text):
                return String(text)
                    .decodingNamedCharacters()
                    .encodingPredefinedXmlEntities()
                    .highlightText()
                    .parseWikilinks(slugify: slugify)
                    .parseNumberalEndingHashtags(processor: hashtagProcessor)
                    .parseRegularHashtags(processor: hashtagProcessor)
                    .parseUnderline()
                
                
            case let .link(text, uri, title):
                if let uri = uri, isRelativeURL(uri) {
                    let titleAttr = title == nil ? "" : " title=\"\(title!)\""
                    return fileBlockProcessor?(text.rawDescription) ?? "<a href=\"\(uri)\"\(titleAttr)>" + self.generate(text: text) + "</a>"
                } else {
                    let titleAttr = title == nil ? "" : " title=\"\(title!)\""
                    return "<a href=\"\(uri ?? "")\"\(titleAttr)>" + self.generate(text: text) + "</a>"
                }
            default:
                return super.generate(textFragment: fragment)
            }
        }
    }
}
