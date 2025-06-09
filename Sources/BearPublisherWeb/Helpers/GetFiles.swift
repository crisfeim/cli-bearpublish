//
//  File.swift
//  
//
//  Created by Cristian Felipe Patiño Rojas on 08/09/2023.
//

import Foundation


public func getFileContents(_ filename: String, ext: String) -> String {
    let url = Bundle.module.url(forResource: filename, withExtension: ext)
    let fileContent = try? String(contentsOf: url!, encoding: .utf8)
    return fileContent!
}

public func getCSSFile(_ filename: String) -> String {
    let url = Bundle.module.url(forResource: filename, withExtension: "css")
    let fileContent = try? String(contentsOf: url!, encoding: .utf8)
    return fileContent!
}


public func getJSFile(_ filename: String) -> String {
    let url = Bundle.module.url(forResource: filename, withExtension: "js")
    let fileContent = try? String(contentsOf: url!, encoding: .utf8)
    return fileContent!
}

func getSVGFile(_ filename: String) -> String {
    let url = Bundle.module.url(forResource: filename, withExtension: "html")
    let fileContent = try? String(contentsOf: url!, encoding: .utf8)
    return fileContent!
}
