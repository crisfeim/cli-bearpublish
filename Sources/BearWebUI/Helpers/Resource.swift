//
//  File.swift
//  
//
//  Created by Cristian Felipe Patiño Rojas on 24/10/2023.
//

public struct Resource {
    
    fileprivate let name: String
    fileprivate let fileExtension: String
    
    public let content: String
    public var fileName: String { "\(name)-\(hash).\(fileExtension)" }
    
    var hash: String { content.makeHash(maxLength: 5) }
    var fullPath: String { "/assets/\(fileExtension)/\(fileName)" }
    
    public init(
        name: String,
        fileExtension: String,
        content: String
    ) {
        self.name = name
        self.fileExtension = fileExtension
        self.content = content
    }
}


#warning("There's already a hash method. See Core.SSG file")
private extension String {
    func makeHash(maxLength: Int = 20) -> String {
        hash.description.replacingOccurrences(of: "-", with: "").prefix(maxLength) + ""
    }
}
