//
//  File.swift
//  
//
//  Created by Cristian Felipe Patiño Rojas on 08/09/2023.
//

import BearPublisherWeb

// MARK: - Processors to be injected into the parser
extension Core {
    
    func parse(id: String, content: String) -> String {
        parser.parse(noteId: id, content: content)
    }
    
    
    func getHashtagCount(_ hashtag: String) -> Int {
        (try! api.fetchTagTree())
            .flat().filter { $0.path == hashtag }.first?.count ?? 0
    }
    
     func hashtagProcessor(_ hashtag: String) -> String {
         Main.Hashtag(
            hashtag: hashtag,
            count: getHashtagCount(hashtag),
            spaModeEnabled: spa
         ).render()
    }
    
    func imgRouter(_ img: String) -> String {
        guard let id = try? api.getFileId(with: img.removingPercentEncoding ?? img) else {
            return "<p>id not found for \(img)</p>"
        }
        
        return """
        <img src="/images/\(id)/\(img)"/>
        """
    }
    
    func fileblockProcessor(_ title: String) -> String {
        guard let data = try? api.getFileData(from: title)?.toFileBlock() else {
            return "@todo: Error, handle this case"
        }
        
        return FileBlock.Renderer(data: data).render()
    }
}
