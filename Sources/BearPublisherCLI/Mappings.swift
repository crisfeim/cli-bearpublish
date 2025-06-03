//
//  File.swift
//  
//
//  Created by Cristian Felipe Patiño Rojas on 03/06/2023.
//
import BearPublisherDataSource
import BearPublisherMarkdown
import BearPublisherWeb
import Foundation


extension File {
    func toFileBlock() -> FileBlock.Data {
        .init(id: id, name: name, date: date, extension: `extension`, size: size)
    }
}

extension [Note] {
    func toNoteListModels() -> [NoteList.Model] {
        self.map { $0.toNoteListModel() }
            .defaultSort()
    }
}

extension [Hashtag] {
    func toMenuModels() -> [Menu.Model] {
        self.map { $0.toMenuModel() }
            .defaultSort()
    }
}

extension Hashtag {
    func toMenuModel() -> Menu.Model {
        .init(
            name: name,
            fullPath: path.replacingOccurrences(of: "/", with: "&"),
            count: count,
            children: children.map {$0.toMenuModel()},
            isPinned: isPinned,
            isSelected: false,
            type: .tag,
            icon: .tag
        )
    }
}

extension Note {
    func makeMethod(from action: @escaping (BearParser.Note) -> String) -> (String, String) -> String {
        return { id, content in
            let note = BearParser.Note(id: id, content: content)
            return action(note)
        }
    }
    
    func toMainModel(parse: @escaping (BearParser.Note) -> String) -> Main.Model {
        return toMainModel(parse: makeMethod(from: parse))
    }
    
    func toMainModel(parse: (String, String) -> String) -> Main.Model {
        let content = isPrivate ? "" : content
        return .init(
            id: uuid,
            title: title ?? "",
            content: parse(uuid, content ?? ""),
            description: subtitle,
            slug: slugify(title ?? ""),
            isPrivate: isPrivate
        )
    }
   
    func toNoteListModel(isSelected: Bool = false) -> NoteList.Model {
        .init(
            id: id,
            title: makeTitle(),
            slug: slugify(title ?? "Nota sin título"),
            isSelected: isSelected,
            isPinned: pinned,
            isEncrypted: isPrivate,
            isEmpty: isEmpty(),
            subtitle: makeSubtitle(),
            creationDate: creationDate,
            modificationDate: modificationDate
        )
    }
}
