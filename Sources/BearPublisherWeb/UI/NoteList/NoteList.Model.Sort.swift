//
//  File.swift
//  
//
//  Created by Cristian Felipe Patiño Rojas on 08/09/2023.
//

import Foundation


extension [NoteList.Model] {
   public func defaultSort() -> Self {
        self.sorted(by: { ($0.creationDate ?? Date()) > ($1.creationDate ?? Date()) })
            .sorted(by: { $0.isPinned && !$1.isPinned })
    }
}
