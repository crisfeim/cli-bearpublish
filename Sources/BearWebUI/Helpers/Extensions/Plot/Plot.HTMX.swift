// © 2025  Cristian Felipe Patiño Rojas. Created on 9/6/25.

import Plot

extension Component {
    
    func hxGet(_ route: String) -> Component {
        attribute(named: "hx-get", value: route)
    }
    
    func hxTarget(_ target: String) -> Component {
        attribute(named: "hx-target", value: target)
    }
    
    func hxPushUrl(_ route: String) -> Component {
        attribute(named: "hx-push-url", value: route)
    }
    
    /// Specifies the element that will have the htmx-request class added to it for the duration of the request.
    func hxIndicator(_ indicator: Indicator) -> Component {
        attribute(named: "hx-indicator", value: indicator.value)
    }
    
    func hxSwap(_ value: String) -> Component {
        attribute(named: "hx-swap", value: value)
    }
}
