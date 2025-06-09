// © 2025  Cristian Felipe Patiño Rojas. Created on 9/6/25.

import Plot

extension Node where Context: HTMLScriptableContext {
    static func script(type: String = "text/javascript", _ script: String) -> Node {
        .element(named: "script", nodes: [
            .attribute(named: "type", value: type),
            .raw(script)
        ])
    }
}
