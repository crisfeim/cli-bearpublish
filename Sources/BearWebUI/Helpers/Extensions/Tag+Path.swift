//
//  File.swift
//
//
//  Created by Cristian Felipe Patiño Rojas on 08/09/2023.
//

import BearDomain

extension Tag {
    var path: String {
        return "/tag/\(fullPath).html"
    }
    
    func makePath() -> String {
        "/?tag=\(fullPath.replacingOccurrences(of: "&", with: "/"))"
    }
}
