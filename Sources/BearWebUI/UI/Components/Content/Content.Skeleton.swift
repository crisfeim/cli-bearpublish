// © 2025  Cristian Felipe Patiño Rojas. Created on 9/6/25.


import Plot

extension Content {
    struct Skeleton: Component {
        var body: Component {
            Div {
                Div {}.class("title-placeholder")
                Div {}.class("text-placeholder")
                Div {}.class("text-placeholder")
                Div {}.class("text-placeholder")
                Div {}.class("text-placeholder")
                Div {}.class("text-placeholder")
                Div {}.class("text-placeholder")
            }
            .class("skeleton main-indicator")
            .style("padding-top: 24px")
        }
    }
}
