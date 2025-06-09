// © 2025  Cristian Felipe Patiño Rojas. Created on 4/6/25.


import Foundation

public struct Note {
    public let id: Int
    public let uuid: String
    public let title: String?
    public let subtitle: String?
    public let content: String?
    public let isArchived: Bool
    public let isEncrypted: Bool
    public let hasFiles: Bool
    public let hasImages: Bool
    public let hasSourceCode: Bool
    public let isPinned: Bool
    public let todoCompleted: Int
    public let todoIncompleted: Int
    public let isTrashed: Bool
    public let creationDate: Date?
    public let modificationDate: Date?
    public let lastEditingDevice: String
    
    public init(
        id: Int,
        uuid: String,
        title: String?,
        subtitle: String?,
        content: String?,
        isArchived: Bool,
        isEncrypted: Bool,
        hasFiles: Bool,
        hasImages: Bool,
        hasSourceCode: Bool,
        isPinned: Bool,
        todoCompleted: Int,
        todoIncompleted: Int,
        trashed: Bool,
        creationDate: Date?,
        modificationDate: Date?,
        lastEditingDevice: String
    ) {
        self.id = id
        self.uuid = uuid
        self.title = title
        self.subtitle = subtitle
        self.content = content
        self.isArchived = isArchived
        self.isEncrypted = isEncrypted
        self.hasFiles = hasFiles
        self.hasImages = hasImages
        self.hasSourceCode = hasSourceCode
        self.isPinned = isPinned
        self.todoCompleted = todoCompleted
        self.todoIncompleted = todoIncompleted
        self.isTrashed = trashed
        self.creationDate = creationDate
        self.modificationDate = modificationDate
        self.lastEditingDevice = lastEditingDevice
    }
}

extension Note: Codable {
    enum CodingKeys: String, CodingKey {
        case id = "Z_PK"
        case uuid = "ZUNIQUEIDENTIFIER"
        case title = "ZTITLE"
        case subtitle = "ZSUBTITLE"
        case content = "ZTEXT"
        case isArchived = "ZARCHIVED"
        case isEncrypted = "ZENCRYPTED"
        case hasFiles = "ZHASFILES"
        case hasImages = "ZHASIMAGES"
        case hasSourceCode = "ZHASSOURCECODE"
        case isPinned = "ZPINNED"
        case todoCompleted = "ZTODOCOMPLETED"
        case todoIncompleted = "ZTODOINCOMPLETED"
        case isTrashed = "ZTRASHED"
        case modificationDate = "ZMODIFICATIONDATE"
        case creationDate = "ZCREATIONDATE"
        case lastEditingDevice = "ZLASTEDITINGDEVICE"
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        uuid = try container.decode(String.self, forKey: .uuid)
        title = try container.decodeIfPresent(String.self, forKey: .title)
        subtitle = try container.decodeIfPresent(String.self, forKey: .subtitle)
        content = try container.decodeIfPresent(String.self, forKey: .content)
        isArchived = try container.decode(Bool.self, forKey: .isArchived)
        isEncrypted = try container.decode(Bool.self, forKey: .isEncrypted)
        hasFiles = try container.decode(Bool.self, forKey: .hasFiles)
        hasImages = try container.decode(Bool.self, forKey: .hasImages)
        hasSourceCode = try container.decode(Bool.self, forKey: .hasSourceCode)
        isPinned = try container.decode(Bool.self, forKey: .isPinned)
        todoCompleted = try container.decode(Int.self, forKey: .todoCompleted)
        todoIncompleted = try container.decode(Int.self, forKey: .todoIncompleted)
        let modDate = try container.decode(Double.self, forKey: .modificationDate)
        modificationDate = Date(timeIntervalSinceReferenceDate: modDate)
        isTrashed = try container.decode(Bool.self, forKey: .isTrashed)
        
        if let doubleValue = try? container.decodeIfPresent(Double.self, forKey: .creationDate) {
            creationDate = Date(timeIntervalSinceReferenceDate: doubleValue)
        } else if let intValue = try? container.decodeIfPresent(Int.self, forKey: .creationDate) {
            creationDate = Date(timeIntervalSinceReferenceDate: Double(intValue))
        } else {
            
            /// Creation Date is a required value that always exists within a note.
            /// This case should never happen
           creationDate = nil
        }
        lastEditingDevice = try container.decode(String.self, forKey: .lastEditingDevice)
    }
}
