//
//  Created by Cristian Felipe Patiño Rojas on 07/09/2023.
//

import Plot
import BearDomain

struct MenuView: Component, Equatable {
    let menu: Menu
    let tags: [Tag]
   
    @ComponentBuilder
    var body: Component {
        Section {
            Cell(
                icon: .note,
                item: menu,
                getRouter: { _ in "" },
                pushedURL: { _ in "" })
        }
        Section {
            for tag in tags {
                Cell(
                    icon: .tag,
                    item: tag,
                    getRouter: { "/standalone/tag/\($0).html" },
                    pushedURL: {
                    "/?tag=\($0.replacingOccurrences(of: "&", with: "/"))"
                })
            }
        }
    }
}

extension Tag: MenuView.Item {}


