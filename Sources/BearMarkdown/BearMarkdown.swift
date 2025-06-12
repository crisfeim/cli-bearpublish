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
