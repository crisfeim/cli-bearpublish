//
//  File.swift
//  
//
//  Created by Cristian Felipe Patiño Rojas on 08/09/2023.
//

extension String {
    public var safeHash: String {
        "h" + hash.description.replacingOccurrences(of: "-", with: "").prefix(10)
    }
}
