// © 2025  Cristian Felipe Patiño Rojas. Created on 13/6/25.

import Foundation

extension String {
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

}
