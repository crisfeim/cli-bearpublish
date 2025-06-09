// © 2025  Cristian Felipe Patiño Rojas. Created on 9/6/25.

import Plot

public protocol View {
    var body: HTML { get }
}

public extension View {
    func render() -> String { body.render() }
}
