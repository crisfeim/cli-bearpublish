import Foundation
import SQLite
import SQLite3


public typealias StringProcesor = (String) -> String
public final class BearDb {
    
    var db: Connection!
    
    // MARK: -  Common Tables & Expressions
    private let archived = SQLite.Expression<Bool>(DBNote.CodingKeys.isArchived.rawValue)
    private let  trashed = SQLite.Expression<Bool>(DBNote.CodingKeys.isTrashed.rawValue )
    
    var slugify: ((SQLite.Expression<String>) -> SQLite.Expression<String>)?
    
    public init(path: String) throws {
        db = try Connection(path, readonly: true)
    }
    
    public func setSlugify(_ processor: @escaping StringProcesor) throws {
        self.slugify = (
            try db.createFunction("slugify", deterministic: true) {processor($0)}
        )
    }
    
    public func close() {
        sqlite3_close(db.handle)
    }
    
    // MARK: - Notes
    /// Fetches all notes. Including trashed and archived
    public func fetchAll() throws -> [DBNote] {
        try db.prepare(Self.notes().table).map { try $0.decode() }
    }
    
    /// Fetches all notes but archived and trashed
    public func fetchNotes() throws -> [DBNote] {
        let query = Self.notes().table.filter(!archived && !trashed)
        return try db.prepare(query).map { try $0.decode() }
    }
    
    /// Fetches all archived notes but trashed
    public func fetchArchived() throws -> [DBNote] {
        let query = Self.notes().table.filter(archived && !trashed)
        return try db.prepare(query).map { try $0.decode() }
    }
    
    /// Fetches all trashed notes, may be archived or not
    public func fetchTrashed() throws -> [DBNote] {
        let query = Self.notes().table.filter(trashed)
        return try db.prepare(query).map { try $0.decode() }
    }
    
    /// Fetches all encrypted notes but archived & trashed
    public func fetchEncrypted() throws -> [DBNote] {
        
        let encrypted = Expression<Bool>(DBNote.CodingKeys.isEncrypted.rawValue)
        let query = Self.notes().table.filter(encrypted && !archived && !trashed)
        return try db.prepare(query).map { try $0.decode() }
    }
    
    /// @nicetohave:
    ///     - Range dates goes from 22 to 22
    ///     - Use SQlite.swift methods
    /// Fetches today notes, not trashed & not archived
    public func fetchToday() throws -> [DBNote] {
        let calendar = Calendar.current
        let start = calendar.startOfDay(for: Date())
        let end = calendar.date(byAdding: .day, value: 1, to: start)!
        return try fetchNotes().filter { start...end ~= $0.creationDate }
    }
    
    /// Fetches notes with active incompleted tasks that aren't archived or trashed
    public func fetchTasks() throws -> [DBNote] {
        let tasks = Expression<Int>(DBNote.CodingKeys.todoIncompleted.rawValue)
        let query = Self.notes().table.filter(tasks >= 1 && !archived && !trashed)
        return try db.prepare(query).map { try $0.decode() }
    }
    
    /// Fetches all untaggged notes that aren't archived or trashed
    public func fetchUntagged() throws -> [DBNote] {
        
        let note_id    = Expression<Int>("Z_PK")
        let join_table = Table("Z_5TAGS")
        let _note_id   = Expression<Int>("Z_5NOTES")
        let _tag_id    = Expression<Int?>("Z_13TAGS")
        
        let query = Self.notes().table
            .join(.leftOuter, join_table, on: note_id == join_table[_note_id])
            .filter(join_table[_tag_id] == nil && !archived && !trashed)
        
         return try db.prepare(query).map { try $0.decode() }
    }
    
   
    // MARK: - Tag
    public func fetchTagTree() throws -> [DBTag] {
        let tags = try fetchTags()
        return TagParser.parse(tags: tags)
    }
    
    public func fetchTags() throws -> [DBTag] {
        let query = """
        SELECT
        ZSFNOTETAG.Z_PK,
        ZSFNOTETAG.ZTITLE,
        ZSFNOTETAG.ZTAGCON,
        ZSFNOTETAG.ZPINNED,
        COUNT(Z_5TAGS.Z_5NOTES) AS ZCOUNT
        FROM ZSFNOTETAG
        LEFT JOIN Z_5TAGS ON ZSFNOTETAG.Z_PK = Z_5TAGS.Z_13TAGS
        LEFT JOIN ZSFNOTE ON Z_5TAGS.Z_5NOTES = ZSFNOTE.Z_PK
        WHERE ZSFNOTE.ZTRASHED = 0 AND ZSFNOTE.ZARCHIVED = 0
        GROUP BY ZSFNOTETAG.Z_PK, ZSFNOTETAG.ZTAGCON, ZSFNOTETAG.ZTITLE
        """
        
        return try db.prepare(query).compactMap { tag(from: $0) }.filter {$0.count > 0}
    }
    
    // MARK: - Note Detail
    /// @nicetohave: "Use lib methods for uniform project conventions"
    /// Fetches all tagged notes that aren't trashed or archived
    public func fetchNotes(with tag: String) throws -> [DBNote] {
        let query = """
        SELECT
        ZSFNOTE.Z_PK,
        ZSFNOTE.ZUNIQUEIDENTIFIER,
        ZSFNOTE.ZTITLE,
        ZSFNOTE.ZSUBTITLE,
        ZSFNOTE.ZTEXT,
        ZSFNOTE.ZARCHIVED,
        ZSFNOTE.ZENCRYPTED,
        ZSFNOTE.ZHASFILES,
        ZSFNOTE.ZHASIMAGES,
        ZSFNOTE.ZHASSOURCECODE,
        ZSFNOTE.ZPINNED,
        ZSFNOTE.ZTODOCOMPLETED,
        ZSFNOTE.ZTODOINCOMPLETED,
        ZSFNOTE.ZTRASHED,
        ZSFNOTE.ZMODIFICATIONDATE,
        ZSFNOTE.ZCREATIONDATE,
        ZSFNOTE.ZLASTEDITINGDEVICE,
        ZSFNOTETAG.ZTAGCON,
        ZSFNOTETAG.ZTITLE AS TAGTITLE FROM ZSFNOTE
        JOIN Z_5TAGS ON ZSFNOTE.Z_PK = Z_5TAGS.Z_5NOTES
        JOIN ZSFNOTETAG ON Z_5TAGS.Z_13TAGS = ZSFNOTETAG.Z_PK
        WHERE TAGTITLE = '\(tag)' AND ZTRASHED LIKE 0 AND ZARCHIVED LIKE 0
        """
        
         return try db.prepare(query).map { try note(from: $0) }
    }
    
    // MARK: - Detail
    public func fetchNote(id: Int) throws -> DBNote? {
        let _id = Expression<Int>("Z_PK")
        let query = Self.notes().table.where(_id == id)
        return try db.pluck(query).map { try $0.decode() }
    }
    
    public func fetchNote(uuid: String) throws -> DBNote? {
        let _uuid = Expression<String?>("ZUNIQUEIDENTIFIER")
        let query = Self.notes().table.where(_uuid == uuid)
        return try db.pluck(query).map { try $0.decode() }
    }
    
    public func fetchNote(slug: String) throws -> DBNote? {
        guard let slugify = slugify else { return nil }
        let title = Expression<String?>("ZTITLE")
        
        let query = Self.notes().table.filter(slugify(title ?? "") == slug)
        return try db.pluck(query).map { try $0.decode() }
    }
    
    /// @nicetohave: Use lib methods for project consistency
    /// Fetches backlins of a note (that are not trashed or archived)
    public func fetchNoteBacklinks(id: Int) throws -> [DBNote] {
        let query = """
         SELECT
         ZSFNOTE.Z_PK,
         ZSFNOTE.ZUNIQUEIDENTIFIER,
         ZSFNOTE.ZTITLE,
         ZSFNOTE.ZSUBTITLE,
         ZSFNOTE.ZTEXT,
         ZSFNOTE.ZARCHIVED,
         ZSFNOTE.ZENCRYPTED,
         ZSFNOTE.ZHASFILES,
         ZSFNOTE.ZHASIMAGES,
         ZSFNOTE.ZHASSOURCECODE,
         ZSFNOTE.ZPINNED,
         ZSFNOTE.ZTODOCOMPLETED,
         ZSFNOTE.ZTODOINCOMPLETED,
         ZSFNOTE.ZTRASHED,
         ZSFNOTE.ZMODIFICATIONDATE,
         ZSFNOTE.ZCREATIONDATE,
         ZSFNOTE.ZLASTEDITINGDEVICE
         FROM ZSFNOTEBACKLINK
         JOIN ZSFNOTE ON ZSFNOTEBACKLINK.ZLINKEDBY = ZSFNOTE.Z_PK
         WHERE ZSFNOTEBACKLINK.ZLINKINGTO = \(id) AND ZTRASHED LIKE 0 AND ZARCHIVED LIKE 0
        """
        
        return try db.prepare(query).map { try note(from: $0) }.filterDuplicates()
    }
    
    public func getFileData(from fileName: String) throws -> DBFile? {
        let query = """
        SELECT
            ZUNIQUEIDENTIFIER,
            ZFILENAME,
            ZCREATIONDATE,
            ZNORMALIZEDFILEEXTENSION,
            ZFILESIZE
        FROM ZSFNOTEFILE
        WHERE ZFILENAME LIKE "\(fileName)"
        """
        
        return try db.prepare(query).map { try file(from: $0) }.first
    }
    
    public func getFileData(id: String) throws -> DBFile? {
        let query = """
        SELECT
            ZUNIQUEIDENTIFIER,
            ZFILENAME,
            ZCREATIONDATE,
            ZNORMALIZEDFILEEXTENSION,
            ZFILESIZE
        FROM ZSFNOTEFILE
        WHERE ZUNIQUEIDENTIFIER LIKE "\(id)"
        """
        
        return try db.prepare(query).map { try file(from: $0) }.first
    }
    
    public func getFileId(with fileName: String) throws -> String? {
        try getFileData(from: fileName)?.id
    }
    
    public func search(query: String) -> [SearchResultItem] {
        []
    }
    
    public func searchNotes(query: String) throws -> [DBNote] {
        let lowercaseQuery = query.lowercased()
        let sqlQuery = """
        SELECT
        ZSFNOTE.Z_PK,
        ZSFNOTE.ZUNIQUEIDENTIFIER,
        ZSFNOTE.ZTITLE,
        ZSFNOTE.ZSUBTITLE,
        ZSFNOTE.ZTEXT,
        ZSFNOTE.ZARCHIVED,
        ZSFNOTE.ZENCRYPTED,
        ZSFNOTE.ZHASFILES,
        ZSFNOTE.ZHASIMAGES,
        ZSFNOTE.ZHASSOURCECODE,
        ZSFNOTE.ZPINNED,
        ZSFNOTE.ZTODOCOMPLETED,
        ZSFNOTE.ZTODOINCOMPLETED,
        ZSFNOTE.ZTRASHED,
        ZSFNOTE.ZMODIFICATIONDATE,
        ZSFNOTE.ZCREATIONDATE,
        ZSFNOTE.ZLASTEDITINGDEVICE FROM ZSFNOTE
        WHERE LOWER(ZTITLE) LIKE '%' || '\(lowercaseQuery)' || '%'
        """
        
        return try db.prepare(sqlQuery).map { try note(from: $0) }
    }
    
    public func getHashtagCount(_ hashtag: String) -> Int {
        guard let tree = try? fetchTagTree() else { return 0 }
        return tree.flat().filter { $0.path == hashtag }.first?.count ?? 0
    }
}

public struct SearchResultItem {
    public init() {}
}

extension Array where Element == DBNote {
    func filterDuplicates() -> [DBNote] {
        var uniqueNotes: [DBNote] = []
        var processedIDs: Set<Int> = []

        for note in self {
            if !processedIDs.contains(note.id) {
                uniqueNotes.append(note)
                processedIDs.insert(note.id)
            }
        }

        return uniqueNotes
    }
}

// MARK: - Helpers
extension BearDb {
    
    func file(from row: Statement.Element) throws -> DBFile {
       let date = try getDate(from: row[2]!)
       return DBFile(
            id: row[0] as! String,
            name: row[1] as! String,
            date: date,
            extension: row[3] as! String,
            size: Int(row[4] as! Int64)
        )
    }
    
    public static func notes() -> (table: Table, select: [Expressible]) {
        let notes = Table("ZSFNOTE")
        let id = Expression<Int>("Z_PK")
        let uuid = Expression<String?>("ZUNIQUEIDENTIFIER")
        let title = Expression<String?>("ZTITLE")
        let subtitle = Expression<String?>("ZSUBTITLE")
        let content = Expression<String?>("ZTEXT")
        let archived = Expression<Bool>("ZARCHIVED")
        let encrypted = Expression<Bool>("ZENCRYPTED")
        let hasFiles = Expression<Bool>("ZHASFILES")
        let hasImages = Expression<Bool>("ZHASIMAGES")
        let hasSourceCode = Expression<Bool>("ZHASSOURCECODE")
        let pinned = Expression<Bool>("ZPINNED")
        let todoCompleted = Expression<Int>("ZTODOCOMPLETED")
        let todoIncompleted = Expression<Int>("ZTODOINCOMPLETED")
        let trashed = Expression<Bool>("ZTRASHED")
        let modificationDate = Expression<Double>("ZMODIFICATIONDATE")
        let creationDate = Expression<Double>("ZCREATIONDATE")
        let lastEditingDevice = Expression<String>("ZLASTEDITINGDEVICE")
        
        let select: [Expressible] = [
            id,
            uuid,
            title,
            subtitle,
            content,
            archived,
            encrypted,
            hasFiles,
            hasImages,
            hasSourceCode,
            pinned,
            todoCompleted,
            todoIncompleted,
            trashed,
            modificationDate,
            creationDate,
            lastEditingDevice
        ]
      
        return (table: notes.select(select), select: select)
    }
    
    private func getDate(from row: Binding) throws -> Date {
        if let dateAsDouble = row as? Double {
            return Date(timeIntervalSinceReferenceDate: dateAsDouble)
        } else if let dateAsInt = row as? Int64 {
            return Date(timeIntervalSinceReferenceDate: Double(dateAsInt))
        } else {
            throw NotFoundDateError()
        }
    }
    
    func note(from row: Statement.Element) throws -> DBNote {
        let creationDate = try getDate(from: row[14]!)
        let modificationDate = (row[15] as? Double).map { Date(timeIntervalSinceReferenceDate:$0) }
        
       return DBNote(
           id: Int(row[0] as! Int64),
           uuid: row[1] as! String,
           title: row[2] as? String,
           subtitle: row[3] as? String,
           content: row[4] as? String,
           isArchived: row[5] as! Int64 == 1,
           isEncrypted: row[6] as! Int64 == 1,
           hasFiles: row[7] as! Int64 == 1,
           hasImages: row[8] as! Int64 == 1,
           hasSourceCode: row[9] as! Int64 == 1,
           isPinned: row[10] as! Int64 == 1,
           todoCompleted: Int(row[11] as! Int64),
           todoIncompleted: Int(row[12] as! Int64),
           trashed: row[13] as! Int64 == 1,
           creationDate: creationDate,
           modificationDate: modificationDate,
           lastEditingDevice: row[16] as! String
       )
    }
    
    func tag(from row: Statement.Element) -> DBTag? {
//        let id = Int(row[0] as! Int64)
        let path = (row[1] as? String) ?? ""
        let isPinned = row[3] as? Int64
        let count = Int(row[4] as! Int64)
        
        return TagParser.makeTag(
            from: path,
            count: count,
            isPinned: isPinned == 1
        )
    }
}

