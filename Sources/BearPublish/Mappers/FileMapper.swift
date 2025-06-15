// © 2025  Cristian Felipe Patiño Rojas. Created on 11/6/25.

import BearDatabase
import BearDomain
import BearWebUI

import Foundation

enum FileMapper {
    static func map(_ file: DBFile) -> File {
        File(
            id: file.id,
            name: file.name,
            extension: file.extension,
            size: file.size
        )
    }
   
    static func map(_ file: File) -> FileViewModel {
        FileViewModel(
            id: file.id,
            name: file.name,
            creationDate: dMMMyyyyFormatter.execute(file.date ?? Date()) ?? "No creation date",
            ext: file.extension,
            size: file.size
        )
    }
}
