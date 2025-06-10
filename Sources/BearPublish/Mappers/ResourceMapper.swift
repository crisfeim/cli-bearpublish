// © 2025  Cristian Felipe Patiño Rojas. Created on 10/6/25.

import BearWebUI

enum ResourceMapper {
    static func map(_ resource: BearWebUI.Resource) -> Resource {
        Resource(filename: resource.fullPath, contents: resource.content)
    }
}
