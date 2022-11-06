//
//  Model.swift
//  aesUI
//
//  Created by Philipp Dumke on 05.11.22.
//

import Foundation
import SwiftUI

class Model: ObservableObject {

    // Enum to track the state of the matrix operation
    enum operationState {
        case waiting, roundKey, subByte, shiftRows, mixColumns, key
    }
    @Published var state = operationState.waiting {
        willSet {
            objectWillChange.send()
        }
    }

    var gridSize: Int = 4

    @Published var text: String
    @Published var array: Array<Block> {
        willSet {
            objectWillChange.send()
        }
    }
    @Published var key: String = ""
    @Published var result: String = ""
    @Published var roundKeys = Array<String>()

    init(text: String = "") {
        self.text = text
        self.array = Array<Block>()
        for i in 0...15 {
            self.array.append(Block(UInt8(i)))
        }
        self.roundKeys.append("test")
        self.roundKeys.append("test")


    }

    func testmove() {
        withAnimation() {
            let object = array.last
            array = array.dropLast(1)
            array.insert(object!, at: 3)
        }
    }

    func nextState() {
        withAnimation(){
            switch self.state {
            case .roundKey:
                self.state = .subByte
            case .subByte:
                self.state = .shiftRows
            case .shiftRows:
                self.state = .mixColumns
            case .mixColumns:
                self.state = .key
            case .key:
                self.state = .roundKey
            case .waiting:
                self.state = .roundKey
            default:
                self.state = .waiting
            }
        }
    }
    func resetState() {
        self.state = .waiting
    }
}
