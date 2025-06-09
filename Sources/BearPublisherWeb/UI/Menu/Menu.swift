//
//  Created by Cristian Felipe Patiño Rojas on 07/09/2023.
//

import Plot
import BearPublisherDomain

public struct Menu: Component, Equatable {
    let tags: [Tag]
   
    @ComponentBuilder
    public var body: Component {
        // MARK: - Tags
        Section {
            for tag in tags {
                Cell(tag: tag, isSelected: false)
            }
        }
    }
}


