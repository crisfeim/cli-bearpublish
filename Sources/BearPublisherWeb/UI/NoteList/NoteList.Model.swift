import Foundation

extension NoteList {
    public struct Model {
        public let id: Int
        let title: String
        let slug: String
        let isSelected: Bool
        let isPinned: Bool
        let isEncrypted: Bool
        let isEmpty: Bool
        let subtitle: String
        let creationDate: Date?
        let modificationDate: Date?
        
        var dateTime: String {
            creationDate?.dMMMyyyy() ?? "@todo"
        }
        
        public init(
            id: Int,
            title: String,
            slug: String,
            isSelected: Bool,
            isPinned: Bool,
            isEncrypted: Bool,
            isEmpty: Bool,
            subtitle: String,
            creationDate: Date?,
            modificationDate: Date?
        ) {
            self.id = id
            self.title = title
            self.slug = slug
            self.isSelected = isSelected
            self.isPinned = isPinned
            self.isEncrypted = isEncrypted
            self.isEmpty = isEmpty
            self.subtitle = subtitle
            self.creationDate = creationDate
            self.modificationDate = modificationDate
        }
    }
}



fileprivate var defaultFormatter: DateFormatter {
    let formatter = DateFormatter()
    formatter.dateFormat = "d MMM yyyy"
    return formatter
}

// @todo: make fileprivate
public extension Date {
    func dMMMyyyy() -> String {
        defaultFormatter.string(from: self)
    }
}

