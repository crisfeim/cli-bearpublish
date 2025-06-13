// © 2025  Cristian Felipe Patiño Rojas. Created on 10/6/25.


import BearWebUI
import BearDatabase
import BearDomain

struct NotesProvider {
    let bearDb: BearDb
    func get() throws -> [Note] {
        try bearDb.fetchAll().map(NoteMapper.map)
    }
}
