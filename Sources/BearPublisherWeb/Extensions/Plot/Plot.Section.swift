// © 2025  Cristian Felipe Patiño Rojas. Created on 9/6/25.

import Plot

// MARK: - Custom definitions
public extension Node where Context == HTML.BodyContext {
    
    static func section(_ nodes: Self...) -> Node {
        .element(named: "section", nodes: nodes)
    }
}

public extension ElementDefinitions {
    enum Section: ElementDefinition { nonisolated(unsafe) public static var wrapper = Node.section }
}

public typealias Section = ElementComponent<ElementDefinitions.Section>
