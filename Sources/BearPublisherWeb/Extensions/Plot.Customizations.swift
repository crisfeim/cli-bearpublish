//
//  SwiftUIView.swift
//  
//
//  Created by Cristian Felipe Patiño Rojas on 02/09/2023.
//

import Plot

// MARK: - HTMX, Hyperscript and other extensions
extension Component {
    func tabIndex(_ value: Int) -> Component {
        attribute(named: "tabindex", value: value.description)
    }
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
    
    func hyperScript(_ script: String) -> Component {
        attribute(named: "_", value: script)
    }
    
    func hxSwap(_ value: String) -> Component {
        attribute(named: "hx-swap", value: value)
    }
    
    func spacing(_ spacing: StackSpacing) -> Component {
        attribute(named: "spacing", value: spacing.rawValue)
    }
}

public enum StackSpacing: String {
    case xs
    case s
    case m
    case l
    case xl
}

// MARK: - Custom definitions
public typealias BodyContext = HTML.BodyContext
public extension Node where Context == BodyContext {
    static func spacer() -> Self {
        .element(named: "spacer")
    }

    static func hstack(_ nodes: Self...) -> Node {
        .element(named: "hstack", nodes: nodes)
    }
    
    static func vstack(_ nodes: Self...) -> Node {
        .element(named: "vstack", nodes: nodes)
    }
    
    static func section(_ nodes: Self...) -> Node {
        .element(named: "section", nodes: nodes)
    }
    
    static func _script(_ nodes: Self...) -> Node {
        .element(named: "script", nodes: nodes)
    }
}



public extension ElementDefinitions {
    /// Definition for the `<hstack>` element.
    enum HStack: ElementDefinition { nonisolated(unsafe) public static var wrapper = Node.hstack }
    enum VStack: ElementDefinition { nonisolated(unsafe) public static var wrapper = Node.vstack }
    enum Section: ElementDefinition { nonisolated(unsafe) public static var wrapper = Node.section }
    enum Details: ElementDefinition { nonisolated(unsafe) public static var wrapper = Node.details }
    enum Summary: ElementDefinition { nonisolated(unsafe) public static var wrapper = Node.summary }
    enum Script: ElementDefinition { nonisolated(unsafe) public static var wrapper = Node._script }
}

public typealias HStack  = ElementComponent<ElementDefinitions.HStack >
public typealias VStack  = ElementComponent<ElementDefinitions.VStack >
public typealias Section = ElementComponent<ElementDefinitions.Section>
public typealias Details = ElementComponent<ElementDefinitions.Details>
public typealias Summary = ElementComponent<ElementDefinitions.Summary>
public typealias _Script  = ElementComponent<ElementDefinitions.Script >



public struct Spacer: Component {
    public init() {}
    public var body: Component {
        Node.spacer()
    }
}

struct Script: Component {
 let script: String
 var body: Component {
     _Script {
         Raw(text: script)
     }
 }
}

struct Raw: Component {
 let text: String
 var body: Component {
     Node<BodyContext>.raw(text)
 }
}


public extension Node where Context: HTMLScriptableContext {
    static func script(type: String = "text/javascript", _ script: String) -> Node {
        .element(named: "script", nodes: [
            .attribute(named: "type", value: type),
            .raw(script)
        ])
    }
}


extension Node<HTML.BodyContext> {
    static func makeCheckbox(_ sidebarName: String) -> Node<HTML.BodyContext> {
        .input(
            .id("\(sidebarName)-checkbox"),
            .name("\(sidebarName)-checkbox"),
            .attribute(named: "type", value: "checkbox"),
            .attribute(named: "style", value: "display:none"),
            //  @todo: Redundat class due to hashtag regex preventing hyperscript to work with id
            .class("\(sidebarName)-checkbox")
        )
    }
    
    static func menu(_ nodes: Self...) -> Self {
        .element(named: "menu", nodes: nodes)
    }
}


