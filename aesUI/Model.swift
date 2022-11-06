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
        case plaintext, waiting, roundKey, subByte, shiftRows, mixColumns, key, ciphertext
    }
    @Published var state = operationState.plaintext {
        willSet {
            objectWillChange.send()
        }
    }
    @Published var isCalculating = false
    @Published var encrypt = true
    
    var gridSize: Int = 4
    var matrixBlockCount: Int {
        switch self.selectedBitType {
            case MatrixType.bit128:
                return 16
            case MatrixType.bit192:
                return 24
            case MatrixType.bit256:
                return 32
        }
    }
    
    @Published var roundCount = 0
    var maxRounds: Int {
        return 10
    }

    @Published var text: String  {didSet{if text.count > matrixBlockCount {text = String(text.dropLast(text.count - matrixBlockCount))}}}
    @Published var array: Matrix {
        willSet {
            objectWillChange.send()
        }
    }
    @Published var key: String = ""
    @Published var result: String = ""
    @Published var roundKeys = Array<String>()
    
    @Published var selectedBitType = MatrixType.bit128

    init(text: String = "") {
        
        var blocks = [Block]()
//        for i in 0...15 {
//            blocks.append(Block(UInt8(i)))
//        }
        
        self.text = text
        self.array = Matrix(blocks: blocks, typ: MatrixType.bit128)
        
        self.roundKeys.append("test")
        self.roundKeys.append("test")


    }

    func testmove() {
        withAnimation() {
//            let object = array[array.blocks.count - 1]
//            array = array.dropLast(1)
//            array.insert(object!, at: 3)
        }
    }

    func nextState() {
        self.isCalculating = true
        withAnimation(){
            switch self.state {
            case .plaintext:
                // Verschlüsselung
                if self.encrypt {
                    if(self.array.blocks.count != 0) {
                        self.state = .roundKey
                    }
                } // Entschlüsselung
                else {
                    self.state = .plaintext
                }
            case .roundKey:
                // Verschlüsselung
                if self.encrypt {
                    self.state = .subByte
                } // Entschlüsselung
                else {
                    if self.maxRounds == self.roundCount {
                        self.state = .plaintext
                    } else {
                        self.roundCount += 1
                        print(self.roundCount)
                        self.state = .key
                    }
                }
            case .subByte:
                // Verschlüsselung
                if self.encrypt {
                    do {
                        try self.array.subBits()
                    } catch {
                        break
                    }
                    
                    self.state = .shiftRows
                } // Entschlüsselung
                else {
                    do {
                        try self.array.subBitsInvers()
                    } catch {
                        break
                    }
                    
                    self.state = .roundKey
                }
            case .shiftRows:
                // Verschlüsselung
                if self.encrypt {
                    self.array.shiftRows()
                    
                    self.state = .mixColumns
                } // Entschlüsselung
                else {
                    self.array.shiftRowsInvers()
                    
                    self.state = .subByte
                }
            case .mixColumns:
                // Verschlüsselung
                if self.encrypt {
                    self.array.mixColums()
                    
                    self.state = .key
                } // Entschlüsselung
                else {
                    self.array.mixColumsInv()
                    
                    self.state = .shiftRows
                }
            case .key:
                // Verschlüsselung
                if self.encrypt {
                    if self.maxRounds == self.roundCount {
                        self.state = .ciphertext
                    } else {
                        self.roundCount += 1
                        print(self.roundCount)
                        self.state = .roundKey
                    }
                } // Entschlüsselung
                else {
                    self.state = .mixColumns
                }
            case .ciphertext:
                // Verschlüsselung
                if self.encrypt {
                    self.matrixToText()
                    self.state = .ciphertext
                } // Entschlüsselung
                else {
                    self.state = .key
                }
                self.state = .roundKey
            case .waiting:
                self.state = .waiting
//            default:
//                self.state = .waiting
            }
        }
        self.isCalculating = false
    }
    func resetState() {
        self.state = .waiting
    }
    
    func textToMatrix() {
        
        self.state = operationState.plaintext
        self.roundCount = 0
        
        let matrixSize = self.matrixBlockCount
        
        var textArray = self.text.prefix(matrixSize).map{String($0)}
        
        while (textArray.count < matrixSize) {
            textArray.append(" ")
        }
        
        print("Array: \(textArray)")
        
        if self.array.blocks.count != matrixSize {
            var emptyBlocks = [Block]()
            
            for i in 0..<matrixSize {
                emptyBlocks.append(Block(UInt8(Array(textArray[i].utf8.lazy.map { Int($0) })[0])))
            }
            self.array = Matrix(blocks: emptyBlocks, typ: self.selectedBitType)
        }
        
        for i in 0..<textArray.count {
            self.array.blocks[i].value = UInt8(Array(textArray[i].utf8.lazy.map { Int($0) })[0])
        }
    }
    
    func matrixToText() {
        
        var mText = ""
        
        for i in 0..<self.array.blocks.count {
            let data = withUnsafeBytes(of: Int(self.array.blocks[i].value)) { Data($0) }
            mText += String(data: data, encoding: .utf8) ?? ""
            print("Data: \"\(data)\", als String: \"\(String(data: data, encoding: .utf8)!)\"")
        }
        print("Result: \(mText)")
        
        self.result = mText
    }
}
