//
//  Note+Helpers.swift
//  BearKit
//
//  Created by Cristian Felipe Patiño Rojas on 08/09/2023.
//

import BearPublisherDataSource
import BearPublisherWeb
import BearPublisherMarkdown
import BearPublisherDomain

extension BearPublisherDataSource.Note {
    var isPrivate: Bool { encrypted || content?.contains("#privado") ?? false }
    func isEmpty() -> Bool {
        (title ?? "").isEmpty
        && (subtitle ?? "").isEmpty
        && (content ?? "").isEmpty
    }
    
    func makeTitle() -> String {
        guard let title = title, !title.isEmpty else {
            return "Una magnifica nota nueva"
        }
        
        guard title.count < 150 else { return String(title.prefix(150)) + "... "}
        return title
    }
    
    func makeSubtitle() -> String {
        if let subtitle = subtitle, !subtitle.isEmpty {
            return String(subtitle.prefix(60)) + "..."
        }
        
        if let title = title, !title.isEmpty {
            return String(title.prefix(60)) + "..."
        }
        
        return "Mantega la calma y escriba algo"
    }
}

