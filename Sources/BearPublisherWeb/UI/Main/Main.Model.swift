//
//  File.swift
//  
//
//  Created by Cristian Felipe Patiño Rojas on 08/09/2023.
//

import Foundation

extension Main {
    public struct Model {
        public init(id: String, title: String, content: String, description: String? = nil, slug: String, isPrivate: Bool) {
            self.id = id
            self.title = title
            self.content = content
            self.description = description
            self.slug = slug
            self.isPrivate = isPrivate
        }
        
        public let id: String
        public let title: String
        public let content: String
        public let description: String?
        public let slug: String
        public let isPrivate: Bool
    }
}
