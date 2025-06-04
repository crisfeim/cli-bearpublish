//
//  File.swift
//  
//
//  Created by Cristian Felipe Patiño Rojas on 08/09/2023.
//

import BearPublisherDataSource
import BearPublisherWeb
import Plot


extension Core {
    
    public func getIndex(title: String = "🏠 Inicio") -> BaseLayout {
        BaseLayout(
            title: title,
            tags: tags,
            notes: notes
        )
    }

    public func getStandaloneNoteList(withFilter filter: MenuFilter) -> StandaloneNoteList {
        StandaloneNoteList(
            title: filter.title,
            notes: getNotes(filter).toNoteListModels()
        )
    }
}

// MARK: - Menu filter
extension Core {
    public enum MenuFilter: String, CaseIterable {
        
        case all
        case untagged
        case tasks
        case encrypted
        case archived
        case trashed
        
        var title: String {
            switch self {
            case .all: return "Todas"
            case .untagged: return "Sin etiquetar"
            case .tasks: return "Tareas"
            case .encrypted: return "Encriptadas"
            case .archived: return "Archivo"
            case .trashed: return "Papelera"
            }
        }
    }
}

// MARK: - Helpers
private extension Core {
    
    func getNotes(_ filter: MenuFilter) -> [Note] {
        switch filter {
        case .all: return (try? api.fetchNotes()) ?? []
        case .untagged: return (try? api.fetchUntagged()) ?? []
        case .tasks: return (try? api.fetchTasks()) ?? []
        case .encrypted: return (try? api.fetchEncrypted()) ?? []
        case .archived: return (try? api.fetchArchived()) ?? []
        case .trashed: return (try? api.fetchTrashed()) ?? []
        }
    }
}

