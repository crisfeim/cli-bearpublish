// © 2025  Cristian Felipe Patiño Rojas. Created on 9/6/25.

import Plot

public protocol HTMLDocument {
    var body: HTML { get }
}

public extension HTMLDocument {
    func render() -> String { body.render() }
}
