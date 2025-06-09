// © 2025  Cristian Felipe Patiño Rojas. Created on 9/6/25.

import Plot

extension Component {
    
    func hx_get(_ route: String) -> Component {
        attribute(named: "hx-get", value: route)
    }
    
    func hx_target(_ target: String) -> Component {
        attribute(named: "hx-target", value: target)
    }
    
    func hx_push_url(_ route: String) -> Component {
        attribute(named: "hx-push-url", value: route)
    }
    
    /// Specifies the element that will have the htmx-request class added to it for the duration of the request.
    func hx_indicator(_ indicator: Indicator) -> Component {
        attribute(named: "hx-indicator", value: indicator.value)
    }
    
    func hx_swap(_ value: String) -> Component {
        attribute(named: "hx-swap", value: value)
    }
}
