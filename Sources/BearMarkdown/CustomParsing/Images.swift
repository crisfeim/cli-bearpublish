// © 2025  Cristian Felipe Patiño Rojas. Created on 13/6/25.

import Foundation


extension String {
    
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
