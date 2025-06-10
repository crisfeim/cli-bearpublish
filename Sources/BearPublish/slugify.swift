//
//  File.swift
//  
//
//  Created by Cristian Felipe Patiño Rojas on 27/05/2023.
//

import Foundation

extension String {
    static let slugSafeCharacters = CharacterSet(charactersIn: "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz-")
}

// @nicetohave: @todo: This function wont work for non  latin languages (russian, japanese, chinese, arab, etc...)
public func slugify(_ text: String) -> String {
    if let latin = text.applyingTransform(StringTransform("Any-Latin; Latin-ASCII; Lower;"), reverse: false) {
        let urlComponents = latin.components(separatedBy: String.slugSafeCharacters.inverted)
        let result = urlComponents.filter { $0 != "" }.joined(separator: "-")
        
        if result.count > 0 {
            return result
        }
    }
    
    return ""
}
