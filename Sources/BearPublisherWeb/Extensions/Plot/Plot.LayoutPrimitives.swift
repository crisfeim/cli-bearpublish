// © 2025  Cristian Felipe Patiño Rojas. Created on 9/6/25.

import Plot

// MARK: - Node
// Usage: HTML(.hstack(...))
public extension Node where Context == BodyContext {
    static func spacer() -> Self {
        .element(named: "spacer")
    }
    
    static func hstack(_ nodes: Self...) -> Node {
        .element(named: "hstack", nodes: nodes)
    }
    
    static func vstack(_ nodes: Self...) -> Node {
        .element(named: "vstack", nodes: nodes)
    }
}

// MARK: - Result builder
// Usage: HStack { ... }
public extension ElementDefinitions {
    enum HStack: ElementDefinition { nonisolated(unsafe) public static var wrapper = Node.hstack }
    enum VStack: ElementDefinition { nonisolated(unsafe) public static var wrapper = Node.vstack }
}

public typealias HStack  = ElementComponent<ElementDefinitions.HStack>
public typealias VStack  = ElementComponent<ElementDefinitions.VStack>
