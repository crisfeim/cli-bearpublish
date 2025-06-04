//
//  File.swift
//  
//
//  Created by Cristian Felipe Patiño Rojas on 08/09/2023.
//

extension Menu {
    public struct Model: Equatable {
        public init(
            name: String,
            fullPath: String,
            count: Int,
            children: [Self],
            isPinned: Bool,
            isSelected: Bool,
            type: `Type`,
            icon: SVG) {
            self.name = name
            self.fullPath = fullPath
            self.count = count
            self.children = children
            self.isPinned = isPinned
            self.isSelected = isSelected
            self.type = type
            self.icon = icon
        }
        
        public let name: String
        public let fullPath: String
        public let count: Int
        public let children: [Self]
        public let isPinned: Bool
        public let isSelected: Bool
        public let type: Type
        public let icon: SVG
        
        public enum `Type` {
            case tag
            case regular
        }
        
        public var path: String {
            switch type {
            case .regular: return "/list/\(fullPath)"
            case .tag: return "/tag/\(fullPath)"
            }
        }
        
        public func makePath() -> String {
            switch type {
            case .regular: return 
                 "/?list=\(fullPath)"
            case .tag: return
                "/?tag=\(fullPath.replacingOccurrences(of: "&", with: "/"))"
            }
        }
    }
    
}
