//
//  Model.swift
//  aesUI
//
//  Created by Philipp Dumke on 05.11.22.
//

import Foundation
import SwiftUI

class Model: ObservableObject {

    var gridSize: Int = 4
    @Published var text: String
    @Published var array: Array<Block> {
        willSet {
            objectWillChange.send()
        }
    }
    @Published var key: String = ""
    @Published var result: String = ""

    init(text: String = "") {
        self.text = text
        self.array = Array<Block>()
        for i in 0...15 {
            self.array.append(Block(UInt8(i)))
        }

    }

    func testmove() {
        withAnimation() {
            let object = array.last
            array = array.dropLast(1)
            array.insert(object!, at: 3)

        }
    }
}
