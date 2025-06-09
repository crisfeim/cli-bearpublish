//
//  File.swift
//  
//
//  Created by Cristian Felipe Patiño Rojas on 07/09/2023.
//

import Plot

extension String {
    func makeRawNode() -> Node<HTML.BodyContext> {
        .raw(self)
    }
}
