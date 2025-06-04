// © 2025  Cristian Felipe Patiño Rojas. Created on 4/6/25.

import XCTest
import BearPublisherCLI
import BearPublisherDataSource

class SSGTests: XCTestCase {
    
    func test() throws {
        struct ProviderStub: Core.TagsProvider, Core.NotesProvider {
            let notes: [Note]
            let tags: [Hashtag]
            func fetchAll() throws -> [Note] {
                notes
            }
            
            func fetchTagTree() throws -> [Hashtag] {
                tags
            }
        }
        
        let provider = ProviderStub(notes: [ ], tags: [ ])
        let core = Core(tagsProvider: provider, notesProvider: provider, api: ApiDummy())
        let ssg = SSG(core: core, outputURL: tmpURL())
        
        let exp = expectation(description: "Wait build to complete")
        try ssg.build {
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1.0)
    }
    
    func tmpURL() -> URL {
        FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
    }
}

// MARK: - Helpers
private extension SSGTests {
    
    func anyNote() -> Note {
        Note(
            id: 0,
            uuid: UUID().uuidString,
            title: "any title",
            subtitle: "any subtitle",
            content: "any content",
            archived: false,
            encrypted: false,
            hasFiles: false,
            hasImages: false,
            hasSourceCode: false,
            pinned: false,
            todoCompleted: 0,
            todoIncompleted: 0,
            trashed: false,
            creationDate: nil,
            modificationDate: nil,
            lastEditingDevice: "any device"
        )
    }
    
    func anyHashtag() -> Hashtag {
        Hashtag(
            path: "any path",
            count: 0,
            isPinned: false,
            children: []
        )
    }
    
    struct ApiDummy: Core.Api {
        func fetchNotes() throws -> [BearPublisherDataSource.Note] {
            [ ]
        }
        
        func fetchUntagged() throws -> [BearPublisherDataSource.Note] {
            [ ]
        }
        
        func fetchEncrypted() throws -> [BearPublisherDataSource.Note] {
            [ ]
        }
        
        func fetchArchived() throws -> [BearPublisherDataSource.Note] {
            [ ]
        }
        
        func fetchTrashed() throws -> [BearPublisherDataSource.Note] {
            [ ]
        }
        
        func fetchTasks() throws -> [BearPublisherDataSource.Note] {
            [ ]
        }
        
        func fetchNote(slug: String) throws -> BearPublisherDataSource.Note? {
            nil
        }
        
        func fetchNoteBacklinks(id: Int) throws -> [BearPublisherDataSource.Note] {
            [ ]
        }
        
        func fetchNotes(with tag: String) throws -> [BearPublisherDataSource.Note] {
            [ ]
        }
        
        func getFileId(with filenaem: String) throws -> String? {
            nil
        }
        
        func getFileData(from fileName: String) throws -> BearPublisherDataSource.File? {
            nil
        }
        
        func close() {
        }
        
        func fetchTagTree() throws -> [BearPublisherDataSource.Hashtag] {
            []
        }
        
        func fetchAll() throws -> [BearPublisherDataSource.Note] {
            []
        }
    }
}
