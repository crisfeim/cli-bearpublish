//
//  File.swift
//  
//
//  Created by Cristian Felipe Patiño Rojas on 21/05/2023.
//

import Foundation

public enum DatabaseLocation {
    case defaultPath
    case customPath(String)
    
    public var path: String {
        switch self {
        case .defaultPath: return "/Users/\(NSUserName())/Library/Group Containers/9K33E3U3T4.net.shinyfrog.bear/Application Data/database.sqlite"
        case let .customPath(path): return path
        }
    }
}
