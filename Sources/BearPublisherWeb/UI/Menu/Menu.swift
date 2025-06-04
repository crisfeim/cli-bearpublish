//
//  Created by Cristian Felipe Patiño Rojas on 07/09/2023.
//

import Plot

public struct Menu: Component, Equatable {
    let tags: [Menu.Model]
    public init(tags: [Menu.Model] = []) {
        self.tags = tags
    }
    
    @ComponentBuilder
    public var body: Component {
        Section {
            Row(model: DefaultItems.all.model)
            Row(model: DefaultItems.archived.model)
            Row(model: DefaultItems.trashed.model)
        }
        
        // MARK: - Tags
        Section {
            for tag in tags {
                Row(model: tag)
            }
        }
    }
}


