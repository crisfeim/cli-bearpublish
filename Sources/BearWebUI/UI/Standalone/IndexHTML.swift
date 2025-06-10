import Plot
import BearDomain

public struct IndexHTML: Equatable, HTMLDocument {
    private let title: String
    private let tags: [Tag]
    private let notes: [Note]
    
    public init(
        title: String,
        tags: [Tag],
        notes: [Note],
    ) {
        self.title = title
        self.tags = tags
        self.notes = notes
    }
    
    public var body: HTML {
        HTML(
            .lang(.spanish),
            .head(
                .title(title),
                .meta(.charset(.utf8)),
                .meta(
                    .attribute(named: "name", value: "viewport"),
                    .attribute(named: "content", value: "initial-scale=1")
                ),
                .forEach(css, {.stylesheet($0.fullPath)}),
                .forEach(Self.headJS(), { .script(.src($0.fullPath)) })
            ),
            .body(
                .class("js-off"),
                .makeCheckbox("menu"),
                .makeCheckbox("nav"),
                .menu(.component(Menu(tags: tags)), .class("js-element")),
                .nav(.component(NoteList(title: "Notes", notes: notes))),
                .main(.component(Content(content: nil))),
                .script(type: "text/hyperscript", layoutScript),
                .forEach(Self.bodyJS(), { .script(.src($0.fullPath)) })
            )
        )
    }
}

private extension IndexHTML {
    var layoutScript: String {
        getFileContents("layout", ext: "hs")
    }
    
    var css: [Resource] {
        Self.css()
    }
}

public extension IndexHTML {
    static func css() -> [Resource] {
        let app    = getCSSFile("app")
        let bear   = getCSSFile("bear")
        let layout = getCSSFile("layout")
        let pylon  = getCSSFile("pylon")
        let vars   = getCSSFile("theme-variables")
        
        let mergedCss      = app + bear + layout + pylon
        
        let styles = Resource(name: "styles"         , fileExtension: "css", content: mergedCss)
        let theme  = Resource(name: "theme-variables", fileExtension: "css", content: vars     )
        
        return [styles, theme]
    }
    
    static func headJS() -> [Resource] {
        [
            Resource(
                name: "htmx",
                fileExtension: "js",
                content: getJSFile("htmx")
            ),
            Resource(
                name: "hyperscript",
                fileExtension: "js",
                content:   getJSFile("hyperscript")
            )
        ]
    }
    
    static func bodyJS() -> [Resource] {
        [Resource(
            name: "main",
            fileExtension: "js",
            content: getJSFile("js") + getJSFile("router")
        )]
    }
   
    static func js() -> [Resource] {
        headJS() + bodyJS()
    }
}
