// © 2025  Cristian Felipe Patiño Rojas. Created on 15/6/25.

import Foundation

enum dMMMyyyyFormatter {
    static func execute(_ date: Date) -> String? {
        defaultFormatter.string(from: date)
    }
    
    private static var defaultFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMM yyyy"
        return formatter
    }
}
