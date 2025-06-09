// © 2025  Cristian Felipe Patiño Rojas. Created on 9/6/25.


import Plot

struct Spacer: Component {
    var body: Component {
        Node.spacer()
    }
}

extension Node where Context == HTML.BodyContext {
    static func spacer() -> Self {
        .element(named: "spacer")
    }
}
