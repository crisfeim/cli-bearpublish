// © 2025  Cristian Felipe Patiño Rojas. Created on 15/6/25.


import Plot

public struct MenuItem: Equatable {
    let name: String
    let fullPath: String
    let notesCount: Int
    let children: [Self]
    let icon: SVG
    
    public init(name: String, fullPath: String, notesCount: Int, children: [Self], icon: SVG) {
        self.name = name
        self.fullPath = fullPath
        self.notesCount = notesCount
        self.children = children
        self.icon = icon
    }
}