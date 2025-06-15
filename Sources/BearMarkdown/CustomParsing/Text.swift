// © 2025  Cristian Felipe Patiño Rojas. Created on 13/6/25.

import Foundation

extension String {
    
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
}

