// © 2025  Cristian Felipe Patiño Rojas. Created on 13/6/25.

import Foundation

extension String {
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
    
    #warning("@todo: inject processor")
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
}
