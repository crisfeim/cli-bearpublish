//
//  File.swift
//  
//
//  Created by Cristian Felipe Patiño Rojas on 21/05/2023.
//
import Foundation


public struct File {
    public let id: String
    public let name: String
    public let date: Date?
    public let `extension`: String
    public let size: Int
}

public struct Note {
    public let id: Int
    public let uuid: String
    public let title: String?
    public let subtitle: String?
    public let content: String?
    public let archived: Bool
    public let encrypted: Bool
    public let hasFiles: Bool
    public let hasImages: Bool
    public let hasSourceCode: Bool
    public let pinned: Bool
    public let todoCompleted: Int
    public let todoIncompleted: Int
    public let trashed: Bool
    public let creationDate: Date?
    public let modificationDate: Date?
    public let lastEditingDevice: String
    
    public init(id: Int, uuid: String, title: String?, subtitle: String?, content: String?, archived: Bool, encrypted: Bool, hasFiles: Bool, hasImages: Bool, hasSourceCode: Bool, pinned: Bool, todoCompleted: Int, todoIncompleted: Int, trashed: Bool, creationDate: Date?, modificationDate: Date?, lastEditingDevice: String) {
        self.id = id
        self.uuid = uuid
        self.title = title
        self.subtitle = subtitle
        self.content = content
        self.archived = archived
        self.encrypted = encrypted
        self.hasFiles = hasFiles
        self.hasImages = hasImages
        self.hasSourceCode = hasSourceCode
        self.pinned = pinned
        self.todoCompleted = todoCompleted
        self.todoIncompleted = todoIncompleted
        self.trashed = trashed
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
        case archived = "ZARCHIVED"
        case encrypted = "ZENCRYPTED"
        case hasFiles = "ZHASFILES"
        case hasImages = "ZHASIMAGES"
        case hasSourceCode = "ZHASSOURCECODE"
        case pinned = "ZPINNED"
        case todoCompleted = "ZTODOCOMPLETED"
        case todoIncompleted = "ZTODOINCOMPLETED"
        case trashed = "ZTRASHED"
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
        archived = try container.decode(Bool.self, forKey: .archived)
        encrypted = try container.decode(Bool.self, forKey: .encrypted)
        hasFiles = try container.decode(Bool.self, forKey: .hasFiles)
        hasImages = try container.decode(Bool.self, forKey: .hasImages)
        hasSourceCode = try container.decode(Bool.self, forKey: .hasSourceCode)
        pinned = try container.decode(Bool.self, forKey: .pinned)
        todoCompleted = try container.decode(Int.self, forKey: .todoCompleted)
        todoIncompleted = try container.decode(Int.self, forKey: .todoIncompleted)
        let modDate = try container.decode(Double.self, forKey: .modificationDate)
        modificationDate = Date(timeIntervalSinceReferenceDate: modDate)
        trashed = try container.decode(Bool.self, forKey: .trashed)
        
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


public struct Tag {
    public let id: Int
    public let title: String
    public let tagCon: String
    public let count: Int
    public let slug: String
    public let childs: [Tag]
    
    public init(id: Int, title: String, tagCon: String, count: Int, slug: String, childs: [Tag]) {
        self.id = id
        self.title = title
        self.tagCon = tagCon
        self.count = count
        self.slug = slug
        self.childs = childs
    }
}

