//
//  File.swift
//
//
//  Created by Cristian Felipe Patiño Rojas on 08/09/2023.
//

import BearDomain

extension Tag {
    func makePath() -> String {
        "/?tag=\(fullPath.replacingOccurrences(of: "&", with: "/"))"
    }
}
