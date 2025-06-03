//
//  File.swift
//  
//
//  Created by Cristian Felipe Patiño Rojas on 08/09/2023.
//

import BearPublisherWeb
import Foundation
import Plot


extension Core {
    struct ViewHolder {
        let slug: String
        let html: HTML
       
        func hash() -> String {
            html.render().makeHash()
        }
    }

    enum NoteLists {
        case defaultFilter
        case backlinks
        case tags
        
        var outputFolder: String {
            switch self {
            case .defaultFilter: return "list"
            case .backlinks    : return "backlinks"
            case .tags         : return "tag"
            }
        }
    }
    
    func getNoteLists(_ lists: NoteLists) -> [ViewHolder] {
        switch lists {
        case .defaultFilter: return getDefaultMenuFilterNoteLists()
        case .backlinks    : return getBacklinkNoteLists()
        case .tags         : return getTagsNoteLists()
        }
    }
}

// MARK: - Helpers
private extension Core {
    
    func getBacklinkNoteLists() -> [ViewHolder] {
        allDbNotes.compactMap {
            let backlinks = (try? api.fetchNoteBacklinks(id: $0.id).toNoteListModels()) ?? []
            guard !backlinks.isEmpty else { return nil }
            let html = StandaloneNoteList(title: "Backlinks", notes: backlinks).body
            return ViewHolder(slug: slugify($0.title ?? ""), html: html)
        }
    }
    
    func getDefaultMenuFilterNoteLists() -> [ViewHolder] {
        MenuFilter.allCases.map {
            let html = getStandaloneNoteList(withFilter: $0).body
            return Core.ViewHolder(slug: $0.rawValue, html: html)
        }
    }
    
    
    func getTagsNoteLists() -> [ViewHolder] {
        return dbTags
            .flat()
            .map { tag in
                let notes = try? api
                    .fetchNotes(with: tag.path)
                    .toNoteListModels()
                
                let html = StandaloneNoteList(title: tag.path, notes: notes ?? []).body
                return ViewHolder(
                    slug: tag.path.replacingOccurrences(of: "/", with: "&"),
                    html: html
                )
            }
    }
}


// @todo: too many hash functions, unify ??
extension String {
    func makeHash(maxLength: Int = 20) -> String {
        hash.description.replacingOccurrences(of: "-", with: "").prefix(maxLength) + ""
    }
}
