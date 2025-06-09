import Plot

import BearPublisherDomain

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
                .forEach(js.head, { .script(.src($0.fullPath)) })
            ),
            .body(
                .class("js-off"),
                .makeCheckbox("menu"),
                .makeCheckbox("nav"),
                .menu(.component(Menu(tags: tags)), .class("js-element")),
                .nav(.component(NoteList(title: "Notes", notes: notes))),
                .main(.component(Main(content: nil))),
                .script(type: "text/hyperscript", layoutScript),
                .forEach(js.body, { .script(.src($0.fullPath)) })
            )
        )
    }
}

private extension IndexHTML {
    var layoutScript: String {
        getFileContents("layout", ext: "hs")
    }
    
    var css: [Resource] {
        Self.makeCSS()
    }
    
    var js : (head: [Resource], body: [Resource]) {
        Self.makeJS()
    }
}


private extension IndexHTML {
    static func makeCSS() -> [Resource] {
        
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
    
    static func makeJS() -> (head: [Resource], body: [Resource]) {
        
        let _htmx        = getJSFile("htmx")
        let _hyperscript = getJSFile("hyperscript")
        let _js          = getJSFile("js")
        let _router      = getJSFile("router")
        let _main = _js + _router
        
        let htmx       = Resource(name: "htmx"       , fileExtension: "js", content: _htmx       )
        let hypercript = Resource(name: "hyperscript", fileExtension: "js", content: _hyperscript)
        let main       = Resource(name: "main"       , fileExtension: "js", content: _main       )
        
        return (head: [htmx, hypercript], body: [main])
    }
    
}

#warning("There's already a hash method. See Core.SSG file")
extension String {
    func makeHash(maxLength: Int = 20) -> String {
        hash.description.replacingOccurrences(of: "-", with: "").prefix(maxLength) + ""
    }
}


