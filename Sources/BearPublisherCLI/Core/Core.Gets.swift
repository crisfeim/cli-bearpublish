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
    
    public func getIndex(title: String = "🏠 Inicio", spaModeEnabled: Bool) -> BaseLayout {
        BaseLayout(
            title: title,
            tags: tags,
            notes: notes,
            spaModeEnabled: spaModeEnabled
        )
    }

    public func getStandaloneNoteList(withFilter filter: MenuFilter, spaModeEnabled: Bool) -> StandaloneNoteList {
        StandaloneNoteList(
            title: filter.title,
            notes: getNotes(filter).toNoteListModels(),
            spaModeEnabled: spaModeEnabled
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

// MARK: - Get note lists (backlinks, tags, ...) and note detail by id (tag name, note slug, etc...)
// Useful for Server Side
extension Core {
    
    public func getTag(tag: String) -> BaseLayout {
        let notes = try? api.fetchNotes(with: tag)
            .toNoteListModels()

        return BaseLayout(
            title: tag,
            tags: tags,
            notes: notes ?? [],
            spaModeEnabled: true
        )
    }
    
    public func getNotes(_ filter: String) -> BaseLayout {
        guard let filter = MenuFilter.init(rawValue: filter) else {
            return BaseLayout(
                title: "Not found",
                tags: tags,
                notes: [],
                spaModeEnabled: true
            )
        }

        let notes = getNotes(filter).toNoteListModels()

        return BaseLayout(
            title: filter.title,
            tags: tags,
            notes: notes,
            spaModeEnabled: true
        )
    }
    

    public func getNote(_ slug: String) -> BaseLayout {
        if let dbNote = try! api.fetchNote(slug: slug) {
            let note   = dbNote.toNoteListModel(isSelected: true)

            let detail = dbNote.toMainModel(parse: parse)
            let notes  = (notes.filter { $0.id != note.id } + [note])
                .defaultSort()

            return BaseLayout(
                title: detail.title,
                tags: tags,
                notes: notes,
                content: detail.content,
                spaModeEnabled: true
            )
        }

        return BaseLayout(
            title: "Nota no encontrada",
            tags: tags,
            notes: notes,
            spaModeEnabled: true
        )
    }
    
    public func getBacklinks(_ slug: String) -> BaseLayout {
        if
            let note = try? api.fetchNote(slug: slug),
            let notes = try? api.fetchNoteBacklinks(id: note.id).toNoteListModels()
        {
            return BaseLayout(
                title: note.title ?? "",
                tags: tags,
                notes: notes,
                spaModeEnabled: true
            )
        }

        return BaseLayout(
            title: "Backlinks",
            tags: tags,
            notes: notes,
            spaModeEnabled: true
        )
    }
    
    public func getStandaloneNoteDetail(_ slug: String) -> HTML {
        if let note = try! api.fetchNote(slug: slug) {
            let detail = note.toMainModel(parse: parse(id:content:))
            return StandaloneNote(
                title: detail.title,
                slug: detail.slug,
                content: detail.content
            ).body
        }
        return StandaloneNote(
            title: "Note not found",
            slug: "404",
            content: "Not found"
        ).body
    }
}
