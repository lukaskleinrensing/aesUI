//
//  Tile.swift
//  aesUI
//
//  Created by Philipp Dumke on 05.11.22.
//

import Foundation

struct Block: Identifiable {
    var id: UUID
    var value: UInt8
    var text: String {
        return value.description
    }

    init(_ value: UInt8){
        self.value = value
        self.id = UUID()
    }
    init(value: UInt8, id: UUID){
        self.value = value
        self.id = id
    }
}


