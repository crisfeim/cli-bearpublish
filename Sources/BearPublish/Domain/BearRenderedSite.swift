// © 2025  Cristian Felipe Patiño Rojas. Created on 13/6/25.

import BearDomain

public struct BearRenderedSite {
    public let index: Resource
    public let notes: [Resource]
    public let listsByCategory: [Resource]
    public let listsByTag: [Resource]
    public let assets: [Resource]
    
    public init(index: Resource, notes: [Resource], listsByCategory: [Resource], listsByTag: [Resource], assets: [Resource]) {
        self.index = index
        self.notes = notes
        self.listsByCategory = listsByCategory
        self.listsByTag = listsByTag
        self.assets = assets
    }
}
