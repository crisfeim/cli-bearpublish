import Plot

import BearPublisherDomain

/// Base three panel layout (menu, nav note list and main note content)
public struct IndexView: Equatable, View {
    fileprivate let title: String
    fileprivate let tags: [Tag]
    fileprivate let notes: [Note]
    fileprivate let content: String?
    
    fileprivate  let layoutScript = getFileContents("layout", ext: "hs")
    
    
    fileprivate var css: [Resource] { Self.makeCSS() }
    fileprivate var js : (head: [Resource], body: [Resource]) {
        Self.makeJS()
    }
    
    fileprivate var menu: Menu {
        Menu(tags: tags)
    }
    
    fileprivate var nav: Component {
        NoteListView(title: "Notes", notes: notes).list
    }
    
    fileprivate var main: Main {
        Main(content: content)
    }
    
    public init(
        title: String,
        tags: [Tag],
        notes: [Note],
        content: String? = nil,
    ) {
        self.title = title
        self.tags = tags
        self.notes = notes
        self.content = content
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
                .menu(.component(menu), .class("js-element")),
                .nav(.component(nav)),
                .main(.component(main)),
                .script(type: "text/hyperscript", layoutScript),
                .forEach(js.body, { .script(.src($0.fullPath)) })
            )
        )
    }
}



public extension IndexView {
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


