//
//  File.swift
//  
//
//  Created by Cristian Felipe Patiño Rojas on 08/09/2023.
//

import BearPublisherMarkdown
import BearPublisherDataSource

public final class Core {
    public protocol Api {
        func fetchAll() throws -> [Note]
        func fetchTagTree() throws -> [Hashtag]
        func fetchNotes() throws -> [Note]
        func fetchUntagged() throws -> [Note]
        func fetchEncrypted() throws -> [Note]
        func fetchArchived() throws -> [Note]
        func fetchTrashed() throws -> [Note]
        func fetchTasks() throws -> [Note]
        func fetchNote(slug: String) throws -> Note?
        func fetchNoteBacklinks(id: Int) throws -> [Note]
        func fetchNotes(with tag: String) throws -> [Note]
        func getFileId(with filenaem: String) throws -> String?
        func getFileData(from fileName: String) throws -> File?
        func close()
    }

    lazy var parser: BearParser = {
        let parser = BearParser()
        parser.setSlugify(slugify(_:))
        parser.setImgProcessor(imgRouter(_:))
        parser.setHashtagProcessor(hashtagProcessor(_:))
        parser.setBlockProcessor(fileblockProcessor(_:))
        return parser
    }()
    
    let api: Api
    
    public init(api: Api) {
        self.api = api
    }
}

public typealias StringProcessor = (String) -> String

public func makeBearApi(dbLocationPath: String, slugify: @escaping StringProcessor) throws -> BearApi {
    let api = try BearApi(databaseLocation: .customPath(dbLocationPath))
    try api.setSlugify(slugify)
    return api
}

extension BearApi: Core.Api {}
