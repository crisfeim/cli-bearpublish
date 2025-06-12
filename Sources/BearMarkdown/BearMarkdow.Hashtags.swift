// © 2025  Cristian Felipe Patiño Rojas. Created on 13/6/25.

import Foundation

extension String {
    func parseRegularHashtags(processor: ((String) -> String)) -> String {
        let pattern = "(?<=\\s|^)#[a-zA-ZáéíóúüÁÉÍÓÚÜ][a-zA-Z0-9áéíóúüÁÉÍÓÚÜ/\\-]+\\b"
        return self.parseTags(regex: pattern, processor: processor)
    }

    
    func parseNumberalEndingHashtags(processor: ((String) -> String)) -> String {
        let pattern = "(?<!\\S)#(?!\\s)([a-zA-ZÀ-ÖØ-öø-ÿ\\d][a-zA-Z0-9À-ÖØ-öø-ÿ\\-\\s\\/]*?[a-zA-ZÀ-ÖØ-öø-ÿ\\d])#"
        return self.parseTags(regex: pattern, processor: processor)
    }
    
    func parseTags(regex pattern: String, processor: ((String) -> String)) -> String {
        let regex = try! NSRegularExpression(pattern: pattern, options: .caseInsensitive)

        let matches = regex.matches(in: self, options: [], range: NSRange(location: 0, length: self.utf16.count))

        var parsedText = self
        for match in matches.reversed() {
            let hashtagRange = Range(match.range, in: self)!
            let hashtag = String(self[hashtagRange]).replacingOccurrences(of: "#", with: "")
        
            parsedText = parsedText.replacingCharacters(in: hashtagRange, with: processor(hashtag))
        }

        return parsedText
    }
}
