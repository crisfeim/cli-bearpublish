// © 2025  Cristian Felipe Patiño Rojas. Created on 9/6/25.

public enum Router {
    public static func note(_ slug: String) -> String {
        "standalone/note/\(slug).html"
    }
    
    public static func list(_ slug: String) -> String {
        "standalone/list/\(slug).html"
    }

    public static func tag(_ slug: String) -> String {
        "standalone/tag/\(slug).html"
    }
}
