// © 2025  Cristian Felipe Patiño Rojas. Created on 10/6/25.


import BearWebUI
import BearDatabase
import BearDomain

struct TagsProvider {
    let bearDb: BearDb
    func get() throws -> [Tag] {
        try bearDb.fetchTagTree().map(TagMapper.map)
    }
}
