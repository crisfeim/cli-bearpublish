//
//  File.swift
//  
//
//  Created by Cristian Felipe Patiño Rojas on 08/09/2023.
//

import Plot

extension NoteList {
    struct EncryptedPlaceholder: Component {
        var body: Component {
            Div {
                Div().class("encrypted-placeholder")
                Div().class("encrypted-placeholder")
            }
        }
    }
}
