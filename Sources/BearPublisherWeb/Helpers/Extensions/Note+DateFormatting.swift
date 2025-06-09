import Foundation
import BearDomain

extension Note {
    var dateTime: String {
        creationDate?.dMMMyyyy() ?? "@todo"
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
