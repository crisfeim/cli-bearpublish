import Foundation
import BearDomain

extension Note {
    var dateTime: String {
        creationDate?.dMMMyyyy() ?? "No date"
    }
}

fileprivate var defaultFormatter: DateFormatter {
    let formatter = DateFormatter()
    formatter.dateFormat = "d MMM yyyy"
    return formatter
}

public extension Date {
    func dMMMyyyy() -> String {
        defaultFormatter.string(from: self)
    }
}
