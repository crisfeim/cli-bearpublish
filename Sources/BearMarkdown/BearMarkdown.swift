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
