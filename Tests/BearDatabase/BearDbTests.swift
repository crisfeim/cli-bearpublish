import XCTest
import BearDatabase

class BearDbTests: XCTestCase {
    
    func test_fetchAll_retrievesAllNotes() throws {
        let notes = try makeSUT().fetchAll()
        XCTAssertEqual(notes.count, 10)
    }
    
    func test_fetchNotes_retrievesAllNotesButTrashedAndArchived() throws {
        let notes = try makeSUT().fetchNotes()
        XCTAssertEqual(notes.count, 8)
        XCTAssertTrue(notes.map { $0.isArchived }.allSatisfy({ $0 == false }))
        XCTAssertTrue(notes.map { $0.isTrashed }.allSatisfy({ $0 == false }))
    }
    
    func test_fetchArchived_retrievesNonTrashedArchivedNotes() throws {
        let archived = try makeSUT().fetchArchived()
        XCTAssertEqual(archived.count, 1)
        XCTAssertFalse(archived[0].isTrashed)
    }
   
    func test_fetchTrashed_retrievesTrashedNotes() throws {
        let notes = try makeSUT().fetchTrashed()
        XCTAssertEqual(notes.count, 1)
        XCTAssertTrue(notes[0].isTrashed)
    }
    
    func test_fetchEncrypted_retrievesNotTrashedNotArchivedEncryptedNotes() throws {
        let notes = try makeSUT().fetchEncrypted()
        XCTAssertTrue(notes.map { $0.isArchived }.allSatisfy({ $0 == false }))
        XCTAssertTrue(notes.map { $0.isTrashed }.allSatisfy({ $0 == false }))
    }
    
    func test_fetchTasksNotes_retrievesNotTrashedNotArchivedTasksNotes() throws {
        let notes = try makeSUT().fetchTasks()
        XCTAssertEqual(notes.count, 1)
        XCTAssertTrue(notes.map { $0.isArchived }.allSatisfy({ $0 == false }))
        XCTAssertTrue(notes.map { $0.isTrashed }.allSatisfy({ $0 == false }))
    }
    
    func test_fetchUntagged_retrievesNotTrashedNotArchivedUntagged() throws {
        let notes = try makeSUT().fetchUntagged()
        XCTAssertEqual(notes.count, 6)
        XCTAssertTrue(notes.map { $0.isArchived }.allSatisfy({ $0 == false }))
        XCTAssertTrue(notes.map { $0.isTrashed }.allSatisfy({ $0 == false }))
    }
    
    func test_fetchNotesWithTag_retrieveNotTrashedNotArchivedTaggedNotes() throws {
        let dev = try makeSUT().fetchNotes(with: "dev")
        let nested = try makeSUT().fetchNotes(with: "sometag/nested")
        XCTAssertEqual(dev.count, 1)
        XCTAssertEqual(nested.count, 1)
        
        let notes = dev + nested
        XCTAssertTrue(notes.map { $0.isArchived }.allSatisfy({ $0 == false }))
        XCTAssertTrue(notes.map { $0.isTrashed }.allSatisfy({ $0 == false }))
    }
    
    func test_fetchNoteWithId_retrievesExpectedNote() throws {
        let note = try makeSUT().fetchNote(id: 32)
        let expectedTitle = "Note with undone tasks"
        XCTAssertEqual(note?.title, expectedTitle)
    }
    
    func test_fetchNoteWithSlug_retrievesExpectedNote() throws {
        let title = "Note with undone tasks"
        let slug = slugify(title)
        let expectedId = "C55ED633-E895-4345-93BD-F40C9668C290"
        let note = try makeSUT().fetchNote(slug: slug)
        XCTAssertEqual(note?.uuid, expectedId)
    }
    
    func test_fetchNoteWithUuid_retrievesExpectedNote() throws {
        let uuid = "C55ED633-E895-4345-93BD-F40C9668C290"
        let note = try makeSUT().fetchNote(uuid: uuid)
        XCTAssertEqual(note?.title, "Note with undone tasks")
    }
    
    func test_fetchBacklinksf_retrievesExpectedBacklinks() throws {
        let pk = 32
        let backlinks = try makeSUT().fetchNoteBacklinks(id: pk)
        XCTAssertEqual(backlinks.count, 1)
    }
    
    func test_fetchTagTree_retrievesExpectedTagTree() throws {
        let tree = try makeSUT().fetchTagTree()
        XCTAssertEqual(tree.count, 3)
    }
    
    func test_fecthTags_retrievesExpectedTags() throws {
        let tags = try makeSUT().fetchTags()
        XCTAssertEqual(tags.count, 5)
    }
    
    func test_searchNotesWithQuery_retrievesExpectedNotes() throws {
        let notes = try makeSUT().searchNotes(query: "tasks")
        XCTAssertEqual(notes.count, 2)
    }
    
    func test_getHashtagCount_retrievesCorrectTaggedAssociatedNotesCount() throws {
        let notesCount = try makeSUT().getHashtagCount("code")
        XCTAssertEqual(notesCount, 1)
    }
}

// MARK: - Helper
extension BearDbTests {
    
    private func slugify(_ text: String) -> String {text.replacingOccurrences(of: " ", with: "-")}
    
    private func makeSUT() throws -> BearDb {
        let dbPath = Bundle.module.url(forResource: "database", withExtension: "sqlite")!.path
        let db = try BearDb(path: dbPath)
        try db.setSlugify(slugify)
        return db
    }
}
