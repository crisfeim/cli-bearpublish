// © 2025  Cristian Felipe Patiño Rojas. Created on 11/6/25.

import BearDatabase
import BearDomain
import BearWebUI

enum FileMapper {
    static func map(_ file: DBFile) -> File {
        File(
            id: file.id,
            name: file.name,
            extension: file.extension,
            size: file.size
        )
    }
    
    static func map(_ file: File) -> FileUI {
        FileUI(id: file.id, name: file.name, extension: file.extension, size: file.size)
    }
}
