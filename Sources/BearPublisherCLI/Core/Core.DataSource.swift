//
//  File.swift
//  
//
//  Created by Cristian Felipe Patiño Rojas on 24/10/2023.
//

import BearPublisherDataSource
import BearPublisherWeb

extension Core {
    
    // MARK: - Database models
    
    /// All notes, including trashed & archived
    var allDbNotes: [Note] {
        (try? notesProvider.fetchAll()) ?? []
    }
    
    /// All notes but trashed & archived
    var dbNotes: [Note] {
        allDbNotes
            .filter { !$0.trashed }
            .filter { !$0.archived }
    }
    
    /// Raw tags before processing as UI object [Menu.Model]
    var dbTags: [Hashtag] {
        try! tagsProvider.fetchTagTree()
    }
    
    // MARK: - UI models
    
    /// Tags mapped as [Menu.Model] ready to construct and pass into MenuView
    var tags : [Menu.Model] {
        dbTags.toMenuModels()
    }
    
    var notes: [NoteList.Model] {
        dbNotes.toNoteListModels()
    }
}
