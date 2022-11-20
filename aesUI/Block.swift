//
//  Tile.swift
//  aesUI
//
//  Created by Philipp Dumke on 05.11.22.
//

import Foundation
import SwiftUI


struct Block: Identifiable, Hashable {
    static func == (lhs: Block, rhs: Block) -> Bool {
        lhs.id == rhs.id
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    var id: UUID
    var value: UInt8 {
        willSet {
            withAnimation(){
                animationAmount = CGFloat(360)
            }

        }
    }
    
    var text: String {
        return value.description
    }
    
    var binaryRepresentation: String {
        String(self.value, radix: 2)
    }
    
    var history: UInt8?

    var animationAmount = CGFloat(0)

    init(_ value: UInt8){
        self.value = value
        self.id = UUID()
    }
    init(value: UInt8, id: UUID, history: UInt8){
        self.value = value
        self.id = id
        self.history = history
    }

}


