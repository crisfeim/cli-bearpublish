// © 2025  Cristian Felipe Patiño Rojas. Created on 9/6/25.

import Foundation
import BearWebUI
import BearDatabase
import BearDomain
import BearMarkdown

public enum BearPublisherComposer {
    public static func make(dbPath: String, outputURL: URL) throws {}
}

extension BearDb {
    func imgProcessor(_ img: String) -> String {
        guard let id = try? getFileId(with: img.removingPercentEncoding ?? img) else {
            return "<p>id not found for \(img)</p>"
        }
        
        return """
       <img src="/images/\(id)/\(img)"/>
       """
    }
}

import BearWebUI

extension BearDb {
    func hashtagProcessor(_ hashtag: String) -> String {
        ContentView.Hashtag(hashtag: hashtag, count: getHashtagCount(hashtag)).render()
    }
}


extension BearDb {
    func fileblockProcessor(_ title: String) -> String {
          guard let data = try? getFileData(from: title) else {
              return "@todo: Error, handle this case"
          }
          
        return FileBlock.Renderer(data: FileMapper.map(data)).render()
      }
}


