// © 2025  Cristian Felipe Patiño Rojas. Created on 9/6/25.

import Plot

// MARK: - Node
// Usage: HTML(.hstack(...))
public extension Node where Context == HTML.BodyContext {
    
    static func hstack(_ nodes: Self...) -> Node {
        .element(named: "hstack", nodes: nodes)
    }
    
    static func vstack(_ nodes: Self...) -> Node {
        .element(named: "vstack", nodes: nodes)
    }
}


public enum StackSpacing: String {
    case xs
    case s
    case m
    case l
    case xl
}

extension Component {
    func spacing(_ spacing: StackSpacing) -> Component {
        attribute(named: "spacing", value: spacing.rawValue)
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
