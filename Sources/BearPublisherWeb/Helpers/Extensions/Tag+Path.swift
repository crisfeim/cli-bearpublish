//
//  File.swift
//
//
//  Created by Cristian Felipe Patiño Rojas on 08/09/2023.
//

import BearPublisherDomain

extension Tag {
    var path: String {
        //            switch type {
        //            case .regular: return "/list/\(fullPath)"
        return "/tag/\(fullPath)"
    }
    
    func makePath() -> String {
        //            switch type {
        //            case .regular: return
        //                 "/?list=\(fullPath)"
        //            case .tag: return
        "/?tag=\(fullPath.replacingOccurrences(of: "&", with: "/"))"
        //            }
    }
}
