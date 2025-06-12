import Foundation
import RubyGateway
import MarkdownKit

public typealias Processor = (String) -> String

public final class BearMarkdown {
    
    private let slugify: Processor
    private let imgProcessor: Processor
    private let hashtagProcessor: Processor
    private let fileBlockProcessor: Processor
    private let generator: BearHTMLGenerator
    
    public init(
        slugify: @escaping Processor,
        imgProcessor: @escaping Processor,
        hashtagProcessor: @escaping Processor,
        fileBlockProcessor: @escaping Processor
    ) {
        self.slugify = slugify
        self.imgProcessor = imgProcessor
        self.hashtagProcessor = hashtagProcessor
        self.fileBlockProcessor = fileBlockProcessor
        self.generator = BearHTMLGenerator()
        generator.setSlugify(slugify)
        generator.setImgProcessor(imgProcessor)
        generator.setHashtagProcessor(hashtagProcessor)
        generator.setBlockProcessor(fileBlockProcessor)
    }
    
    public func parse(_ content: String) -> String {
        generator.parse(content)
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
            hx-get="/standalone/tag/\(slug).html"
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
