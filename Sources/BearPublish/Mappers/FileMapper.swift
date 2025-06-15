// © 2025  Cristian Felipe Patiño Rojas. Created on 11/6/25.

import BearDatabase
import BearDomain
import BearWebUI

import Foundation

enum FileMapper {
    static func map(_ file: DBFile) -> FileViewModel {
        FileViewModel(
            id: file.id,
            name: file.name,
            creationDate: dMMMyyyyFormatter.execute(file.date) ?? "No creation date",
            ext: file.extension,
            size: file.size
        )
    }
}
