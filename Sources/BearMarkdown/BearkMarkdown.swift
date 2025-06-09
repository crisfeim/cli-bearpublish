import Foundation
import RubyGateway
import MarkdownKit


fileprivate let rightArrow = "test"
fileprivate let leftArrow = """
    <svg style="margin: 0px 3px" width="11px" height="10px" viewBox="0 0 11 10" version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink"><g id="left-arrow" transform="translate(5.500000, 5.000000) scale(-1, 1) translate(-5.500000, -5.000000)"><path d="M1.77635684e-14,5 L9,5" id="rod" stroke="#000000" stroke-width="2"></path> <path d="M11,5 L6,0.5 L6,9.5 L11,5 Z" id="point" fill="#000000"></path></g></svg>
    """

public typealias Processor = (String) -> String

public final class BearkMarkdown: HtmlGenerator {
  
    public struct Note {
        let id: String
        let content: String
        
        public init(id: String, content: String) {
            self.id = id
            self.content = content
        }
    }
    
    var _slugify: Processor?
    var imgProcessor: Processor?
    var hashtagProcessor: Processor?
    var fileBlockProcessor: Processor?
    
    var slugify: Processor {
        _slugify ?? { _ in "no slugify founded injected yet" }
    }
    
    public func setImgProcessor(_ processor: @escaping Processor) {
        imgProcessor = processor
    }
    public func setHashtagProcessor(_ processor: @escaping Processor) {
        hashtagProcessor = processor
    }
    
    public func setBlockProcessor(_ processor: @escaping Processor) {
        fileBlockProcessor = processor
    }
    
    public func setSlugify(_ processor: @escaping Processor) {
        _slugify = processor
    }

    public func parse(noteId: String, content: String) -> String {
        // Custom pre-parsing
        let note = Note(id: noteId, content: content).content
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
    
    public func generate(block: Block, tight: Bool = false) -> String {
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
    
    public override func generate(lines: Lines, separator: String = "\n") -> String {
        let lines = super.generate(lines:  lines, separator: "")
        
        return lines.parseWikilinksCode()
    }
    
    
    public override func generate(textFragment fragment: TextFragment) -> String {
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

func isRelativeURL(_ url: String) -> Bool {
    guard let urlComponents = URLComponents(string: url) else {
        return false
    }
    
    return urlComponents.scheme == nil && urlComponents.host == nil
}


public extension String {
    
    func parseUnderline() -> String {
        let pattern = #"~(.*?)~"#
        let regex = try! NSRegularExpression(pattern: pattern)
        return regex.stringByReplacingMatches(in: self, options: [], range: NSRange(location: 0, length: self.utf16.count), withTemplate: "<u>$1</u>")
    }
   
    func parseRegularHashtags(processor: ((String) -> String)?) -> String {
        let pattern = "(?<=\\s|^)#[a-zA-ZáéíóúüÁÉÍÓÚÜ][a-zA-Z0-9áéíóúüÁÉÍÓÚÜ/\\-]+\\b"
        return self.parseTags(regex: pattern, processor: processor)
    }

    
    func parseNumberalEndingHashtags(processor: ((String) -> String)?) -> String {
        let pattern = "(?<!\\S)#(?!\\s)([a-zA-ZÀ-ÖØ-öø-ÿ\\d][a-zA-Z0-9À-ÖØ-öø-ÿ\\-\\s\\/]*?[a-zA-ZÀ-ÖØ-öø-ÿ\\d])#"
        return self.parseTags(regex: pattern, processor: processor)
    }
    
    func parseTags(regex pattern: String, processor: ((String) -> String)?) -> String {
        let regex = try! NSRegularExpression(pattern: pattern, options: .caseInsensitive)

        let matches = regex.matches(in: self, options: [], range: NSRange(location: 0, length: self.utf16.count))

        var parsedText = self
        for match in matches.reversed() {
            let hashtagRange = Range(match.range, in: self)!
            let hashtag = String(self[hashtagRange]).replacingOccurrences(of: "#", with: "")
        
            if let processor = processor {
                parsedText = parsedText.replacingCharacters(in: hashtagRange, with: processor(hashtag))
            } else {
                
                let slug = hashtag.replacingOccurrences(of: "/", with: "&")
                let replacement = """
            
            <a
            href="/tag/\(slug)"
            hx-get="/standalone/tag/\(slug)"
            hx-target="nav"
            class="hashtag"
            _="on click set .nav-checkbox.checked to false">\(hashtag)</a>
            """
                parsedText = parsedText.replacingCharacters(in: hashtagRange, with: replacement)
            }
        }

        return parsedText
    }
    
    func parseAndReplaceHexColors() -> String {
        let pattern = "#([0-9a-f]{6}|[0-9a-f]{3})"
        let regex = try! NSRegularExpression(pattern: pattern, options: .caseInsensitive)
        
        let matches = regex.matches(in: self, options: [], range: NSRange(location: 0, length: self.utf16.count))
        
        var parsedText = self
        for match in matches.reversed() {
            let colorRange = Range(match.range, in: self)!
            let colorCode = String(self[colorRange])
          
            
            let hashtag = """
            <span class="color-hash">#</span>
            """
            
            let labelSpan = """
            <span>\(hashtag)\(colorCode.replacingOccurrences(of: "#", with: ""))</span>
            """
            
            let colorSpan = """
            <span class="color-preview" style="background:\(colorCode)"></span>
            """
            
            let finalSpan = """
            <span>
            \(colorSpan)
            \(labelSpan)
            </span>
            """
            
            parsedText = parsedText.replacingCharacters(in: colorRange, with: finalSpan)
        }
        
        return parsedText
    }

    
    func parseColors() -> String {
        let pattern = #"([0-9a-f]{6}|#[0-9a-f]{3})"#
        let regex = try! NSRegularExpression(pattern: pattern)
        let range = NSRange(location: 0, length: self.count)
        
        let replacedString = regex.stringByReplacingMatches(
            in: self,
            options: [],
            range: range,
            withTemplate: "color"
        )
        
        return replacedString
    }
    
    func highlightText() -> String {
        let pattern = #"==([^=]+)==+"#
        let regex = try! NSRegularExpression(pattern: pattern)
        let range = NSRange(location: 0, length: self.count)
        
        let replacedString = regex.stringByReplacingMatches(
            in: self,
            options: [],
            range: range,
            withTemplate: "<mark>$1</mark>"
        )
        
        return replacedString
    }
    
    func parseWikilinksCode() -> String {
        let pattern = #"\[\[(.+?)\]\]"#
        let regex = try! NSRegularExpression(pattern: pattern)
        let range = NSRange(location: 0, length: self.count)
        
        let replacedString = regex.stringByReplacingMatches(
            in: self,
            options: [],
            range: range,
            withTemplate: "codewiki$1codewiki"
        )
        
        return replacedString
    }
    
    func correctWikilinksCode() -> String {
        let pattern = #"codewiki(.+?)codewiki"#
        let regex = try! NSRegularExpression(pattern: pattern)
        let range = NSRange(location: 0, length: self.count)
        
        let replacedString = regex.stringByReplacingMatches(
            in: self,
            options: [],
            range: range,
            withTemplate: "[[$1]]"
        )
        
        return replacedString
    }
    
    func parseWikilinks(slugify: (String) -> String) -> String {
        let pattern = #"\[\[(.+?)\]\]"#
        let regex = try! NSRegularExpression(pattern: pattern)
        
        var transformedString = self
        
        let matches = regex.matches(in: self, range: NSRange(self.startIndex..., in: self))
        for match in matches.reversed() {
            let range = Range(match.range(at: 1), in: self)!
            let linkText = self[range]
            
            let slug = String(linkText).components(separatedBy: "/").map { slugify($0) }.joined(separator: "#")
            let href = "\(slug)"
           
            
            let replacement = """
            
            <a
            href="/?slug=\(href)"
            hx-get="/standalone/note/\(href).html"
            hx-target="main"
            hx-push-url="/?slug=\(href)"
            hx-swap="innerHTML scroll:top"
            ><span class="brackets">[[</span>\(linkText)<span class="brackets">]]</span></a>
            """
            transformedString = transformedString.replacingCharacters(in: Range(match.range, in: self)!, with: replacement)
        }
        
        return transformedString
    }
    
    func parseImages(imgProcessor: ((String) -> String)?) -> String {
        let regex = try! NSRegularExpression(pattern: "\\!\\[\\]\\((.*?)\\)")
        let matches = regex.matches(in: self, options: [], range: NSRange(location: 0, length: self.utf16.count))
        
        var parsedText = self
        for match in matches.reversed() {
            let range = Range(match.range, in: self)!
            let img = String(self[range])
            
            let _img = img.getImageName()
            let processed = imgProcessor?(_img) ?? "<img src=\"/images/$1\"/>"
            
            parsedText = parsedText.replacingCharacters(in: range, with: processed)
        }
        
        return parsedText
    }
    
    
    func getImageName() -> String {
        let regex = try! NSRegularExpression(pattern: "\\!\\[\\]\\((.*?)\\)")
        let range = NSRange(location: 0, length: self.utf16.count)
        
        let img = regex.stringByReplacingMatches(
            in: self,
            options: [],
            range: range,
            withTemplate:  "$1"
        )
        
        return img
    }
}
