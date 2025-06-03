//
//  Created by Cristian Felipe Patiño Rojas on 07/09/2023.
//

import Plot

public struct Menu: Component {
    let tags: [Menu.Model]
    let spaModeEnabled: Bool
    public init(tags: [Menu.Model] = [], spaModeEnabled: Bool) {
        self.tags = tags
        self.spaModeEnabled = spaModeEnabled
    }
    
    @ComponentBuilder
    public var body: Component {
        Section {
            Row(model: DefaultItems.all.model, spaModeEnabled: spaModeEnabled)
            Row(model: DefaultItems.archived.model, spaModeEnabled: spaModeEnabled)
            Row(model: DefaultItems.trashed.model, spaModeEnabled: spaModeEnabled)
        }
        
        // MARK: - Tags
        Section {
            for tag in tags {
                Row(model: tag, spaModeEnabled: spaModeEnabled)
            }
        }
    }
}


