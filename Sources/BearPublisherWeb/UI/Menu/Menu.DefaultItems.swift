//
//  File.swift
//  
//
//  Created by Cristian Felipe Patiño Rojas on 08/09/2023.
//

import Foundation

extension Menu {
    enum DefaultItems: String, CaseIterable {
        case all
        case untagged
        case tasks
        case encrypted
        case archived
        case trashed
        
        var title: String {
            switch self {
            case .all: return "Notas"
            case .untagged: return "Sin etiquetar"
            case .tasks: return "Tareas"
            case .encrypted: return "Encriptadas"
            case .archived: return "Archivo"
            case .trashed: return "Papelera"
            }
        }
        
        var children: [Menu.Model] {
            self == .all
            ?  [
                Self.untagged.model,
                Self.tasks.model,
                Self.encrypted.model
            ]
            : []
        }
        
        var icon: SVG {
            switch self {
            case .all: return .note
            case .untagged: return .tag
            case .tasks: return .checkbox
            case .encrypted: return .lock
            case .archived: return .archive
            case .trashed: return .bin
            }
        }
       
        #warning("Count is hardcoded. It should be injected")
        var model: Menu.Model {
            .init(
                name: title,
                fullPath: self.rawValue,
                count: 0,
                children: children,
                isPinned: false,
                isSelected: self == .all,
                type: .regular,
                icon: icon
            )
        }
    }
}
