// © 2025  Cristian Felipe Patiño Rojas. Created on 9/6/25.


import Plot

public struct Spacer: Component {
    public init() {}
    public var body: Component {
        Node.spacer()
    }
}

public extension Node where Context == HTML.BodyContext {
    static func spacer() -> Self {
        .element(named: "spacer")
    }
}
