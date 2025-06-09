//
//  Created by Cristian Felipe Patiño Rojas on 07/09/2023.
//

import Plot
import BearPublisherDomain

struct Menu: Component, Equatable {
    let tags: [Tag]
   
    @ComponentBuilder
    var body: Component {
        Section {
            for tag in tags {
                Cell(tag: tag, isSelected: false)
            }
        }
    }
}


