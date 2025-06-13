// © 2025  Cristian Felipe Patiño Rojas. Created on 11/6/25.

import BearDatabase
import BearDomain

enum FileMapper {
    static func map(_ file: BearDatabase.DBFile) -> BearDomain.File {
        File(
            id: file.id,
            name: file.name,
            extension: file.extension,
            size: file.size
        )
    }
}
