//
//  File.swift
//  
//
//  Created by Cristian Felipe Patiño Rojas on 08/09/2023.
//

import Foundation

extension [Menu.Model] {
    public func defaultSort() -> Self {
        self.sorted(by: { $0.name < $1.name })
            .sorted(by: { $0.isPinned && !$1.isPinned })
    }
}
