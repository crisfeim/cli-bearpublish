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
    
    func hyperScript(_ script: String) -> Component {
        attribute(named: "_", value: script)
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
    
    static func section(_ nodes: Self...) -> Node {
        .element(named: "section", nodes: nodes)
    }
    
    static func _script(_ nodes: Self...) -> Node {
        .element(named: "script", nodes: nodes)
    }
}



public extension ElementDefinitions {
    enum Section: ElementDefinition { nonisolated(unsafe) public static var wrapper = Node.section }
    enum Details: ElementDefinition { nonisolated(unsafe) public static var wrapper = Node.details }
    enum Summary: ElementDefinition { nonisolated(unsafe) public static var wrapper = Node.summary }
    enum Script: ElementDefinition { nonisolated(unsafe) public static var wrapper = Node._script }
}


public typealias Section = ElementComponent<ElementDefinitions.Section>
public typealias Details = ElementComponent<ElementDefinitions.Details>
public typealias Summary = ElementComponent<ElementDefinitions.Summary>
public typealias _Script  = ElementComponent<ElementDefinitions.Script>



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


