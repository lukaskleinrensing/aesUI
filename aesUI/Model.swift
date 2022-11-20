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
    @Published var w0: String = "16909060"
    @Published var w1: String = "84281096"
    @Published var w2: String = "35948948"
    @Published var w3: String = "2509674392"
    @Published var key: Key = Key(initWords: [16909060, 84281096, 35948948, 2509674392])
    @Published var result: String = ""
    @Published var roundKeys = Array<String>()

    @Published var animationSpeed = 1.0
    @Published var selectedBitType = MatrixType.bit128 {
        didSet {
            textToMatrix()
        }
    }
    @Published var selectedBlocks = Set<UUID>()
    @Published var animationAmount = CGFloat(0)


    init(text: String = "") {
        
        let blocks = [Block]()
//        for i in 0...15 {
//            blocks.append(Block(UInt8(i)))
//        }
        
        self.text = text
        self.array = Matrix(blocks: blocks, typ: MatrixType.bit128)
    
    }
    
    func loadStartKeys() {
        self.key = Key(initWords: [UInt32(Int(self.w0) ?? 0), UInt32(Int(self.w1) ?? 0), UInt32(Int(self.w2) ?? 0), UInt32(Int(self.w3) ?? 0)])
    }
    
//MARK: Next State
    func nextState() {
        self.isCalculating = true
//        withAnimation(.easeInOut(duration: animationSpeed)){
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
                    self.matrixToText()
                }
            case .roundKey:
                // Verschlüsselung
                if self.encrypt {
                    print("[RoundKey]Verschlüssele mit \(key.generateRoundKey(round: (self.roundCount)))")
                    self.array.addRoundKey(key.generateRoundKey(round: (self.roundCount)))
                    self.state = .subByte
                } // Entschlüsselung
                else {
                    print("[RoundKey]Entschlüssele mit \(key.generateRoundKey(round: (self.maxRounds - self.roundCount)))")
                    self.array.addRoundKey(key.generateRoundKey(round: (self.maxRounds - self.roundCount)))
                    self.state = .plaintext
                }
            case .subByte:
                // Verschlüsselung
                if self.encrypt {
                 
                        subBits()

                    self.state = .shiftRows
                } // Entschlüsselung
                else {
                    do {
                        try self.array.subBitsInvers()
                    } catch {
                        break
                    }
                    if self.maxRounds == self.roundCount {
                        self.state = .plaintext
                    } else {
                        self.roundCount += 1
                        print(self.roundCount)
                        self.state = .key
                    }
                }
            case .shiftRows:
                // Verschlüsselung
                if self.encrypt {
                    withAnimation(.easeInOut(duration: animationSpeed)){
                        self.array.shiftRows()
                    }
                    self.state = .mixColumns
                } // Entschlüsselung
                else {
                    withAnimation(.easeInOut(duration: animationSpeed)){
                        self.array.shiftRowsInvers()
                    }
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
                    print("[Key]Verschlüssele mit \(key.generateRoundKey(round: (self.roundCount + 1)))")
                    self.array.addRoundKey(key.generateRoundKey(round: (self.roundCount + 1)))
                    if self.maxRounds == self.roundCount {
                        self.state = .ciphertext
                    } else {
                        self.roundCount += 1
                        print(self.roundCount)
                        self.state = .subByte
                    }
                } // Entschlüsselung
                else {
                    print("[Key]Entschlüssele mit \(key.generateRoundKey(round: (self.maxRounds - self.roundCount) + 1))")
                    self.array.addRoundKey(key.generateRoundKey(round: (self.maxRounds - self.roundCount) + 1))
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
//        }
        self.isCalculating = false
    }
    func resetState() {
        self.state = .waiting
    }
    //MARK: TextToMatrix
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
            self.array.blocks[i].value = UInt8(PhilippsEncoding.CharToBase[Character(textArray[i])] ?? 0)
        }
    }
    //MARK: MatrixToText
    func matrixToText() {
        
        var mText = ""
        
        for i in 0..<self.array.blocks.count {
            mText = mText + String(PhilippsEncoding.BaseToCharacter[Int(self.array.blocks[i].value)] ?? Character(" "))
        }
        print("Result: \(mText)")
        
        self.result = mText
    }

    func subBits() {
        do {
            try self.array.subBits()
        } catch  {
            print("Fehler")
        }
    }
    
    func resetApp() {
        self.state = self.encrypt ? .plaintext : .ciphertext
        
        self.text = ""
        self.result = ""
        self.roundCount = 0
        
        let blocks = [Block]()
        self.array = Matrix(blocks: blocks, typ: self.array.typ)
        
        self.roundKeys.removeAll()
        self.selectedBlocks.removeAll()
        
        
    }
}
