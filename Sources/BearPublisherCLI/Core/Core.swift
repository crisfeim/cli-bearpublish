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
    
    public init(
        parser: BearParser,
        api: BearApi
    ) {
            
        self.parser = parser
        self.api = api
    }
    
    public init() {
        self.api = BearApi()
        self.parser = BearParser()
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
