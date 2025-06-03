//
//  File.swift
//  
//
//  Created by Cristian Felipe Patiño Rojas on 08/09/2023.
//

import BearPublisherMarkdown
import BearPublisherDataSource

public final class Core {
    let parser: BearParser
    let api: BearApi
    let spa: Bool
    
    public init(
        parser: BearParser,
        api: BearApi,
        spa: Bool) {
            
        self.parser = parser
        self.api = api
        self.spa = spa
    }
    
    public init(spa: Bool) throws {
        self.api = BearApi()
        self.parser = BearParser()
        self.spa = spa
        parser.setSlugify(slugify(_:))
        parser.setImgProcessor(imgRouter(_:))
        parser.setHashtagProcessor(hashtagProcessor(_:))
        parser.setBlockProcessor(fileblockProcessor(_:))
    }
    
    func setupDB(location: String) throws {
        try api.connect(location: location)
        try api.setSlugify(slugify(_:))
    }
}

public typealias StringProcessor = (String) -> String
