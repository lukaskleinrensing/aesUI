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

    @Published var animationSpeed = 1.0
    @Published var selectedBitType = MatrixType.bit128 {
        didSet {
            textToMatrix()
        }
    }
    @Published var selectedBlocks = Set<UUID>()


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

        withAnimation(.easeInOut(duration: animationSpeed)) {
//            let object = array[array.blocks.count - 1]
//            array = array.dropLast(1)
//            array.insert(object!, at: 3)
        }
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
                    withAnimation(){
                        subBits()
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
                    withAnimation(){
                        self.array.mixColums()
                    }
                    
                    self.state = .key
                } // Entschlüsselung
                else {
                    withAnimation(){
                        self.array.mixColumsInv()
                    }
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
            self.array.blocks[i].value = UInt8(Array(textArray[i].utf8.lazy.map { Int($0) })[0])
        }
    }
    //MARK: MatrixToText
    func matrixToText() {
        
        var mText = ""
        
        for i in 0..<self.array.blocks.count {
            let data = Data(base64Encoded: withUnsafeBytes(of: Int(self.array.blocks[i].value)) { Data($0) })

            mText += String(data: data!, encoding: .utf8) ?? ""
            print("Data: \"\(data)\", als String: \"\(String(data: data!, encoding: .utf8)!)\"")
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

    //MARK: BlockChiffre Shit

    let toBase = [
        0: Character("A"),
        1: Character("B"),
        2: Character("C"),
        3: Character("D"),
        4: Character("E"),
        5: Character("F"),
        6: Character("G"),
        7: Character("H"),
        8: Character("I"),
        9: Character("J"),
        10: Character("K"),
        11: Character("L"),
        12: Character("M"),
        13: Character("N"),
        14: Character("O"),
        15: Character("P"),
        16: Character("Q"),
        17: Character("R"),
        18: Character("S"),
        19: Character("T"),
        20: Character("U"),
        21: Character("V"),
        22: Character("W"),
        23: Character("X"),
        24: Character("Y"),
        25: Character("Z"),
        26: Character("a"),
        27: Character("b"),
        28: Character("c"),
        29: Character("d"),
        30: Character("e"),
        31: Character("f"),
        32: Character("g"),
        33: Character("h"),
        34: Character("i"),
        35: Character("j"),
        36: Character("k"),
        37: Character("l"),
        38: Character("m"),
        39: Character("n"),
        40: Character("o"),
        41: Character("p"),
        42: Character("q"),
        43: Character("r"),
        44: Character("s"),
        45: Character("t"),
        46: Character("u"),
        47: Character("v"),
        48: Character("w"),
        49: Character("x"),
        50: Character("y"),
        51: Character("z"),
        52: Character("0"),
        53: Character("1"),
        54: Character("2"),
        55: Character("3"),
        56: Character("4"),
        57: Character("5"),
        58: Character("6"),
        59: Character("7"),
        60: Character("8"),
        61: Character("9"),
        62: Character("+"),
        63: Character(" ")
        ]

    let fromBase = [
        Character("A") : 0,
        Character("B") : 1,
        Character("C") : 2,
        Character("D") : 3,
        Character("E") : 4,
        Character("F") : 5,
        Character("G") : 6,
        Character("H") : 7,
        Character("I") : 8,
        Character("J") : 9,
        Character("K") : 10,
        Character("L") : 11,
        Character("M") : 12,
        Character("N") : 13,
        Character("O") : 14,
        Character("P") : 15,
        Character("Q") : 16,
        Character("R") : 17,
        Character("S") : 18,
        Character("T") : 19,
        Character("U") : 20,
        Character("V") : 21,
        Character("W") : 22,
        Character("X") : 23,
        Character("Y") : 24,
        Character("Z") : 25,
        Character("a") : 26,
        Character("b") : 27,
        Character("c") : 28,
        Character("d") : 29,
        Character("e") : 30,
        Character("f") : 31,
        Character("g") : 32,
        Character("h") : 33,
        Character("i") : 34,
        Character("j") : 35,
        Character("k") : 36,
        Character("l") : 37,
        Character("m") : 38,
        Character("n") : 39,
        Character("o") : 40,
        Character("p") : 41,
        Character("q") : 42,
        Character("r") : 43,
        Character("s") : 44,
        Character("t") : 45,
        Character("u") : 46,
        Character("v") : 47,
        Character("w") : 48,
        Character("x") : 49,
        Character("y") : 50,
        Character("z") : 51,
        Character("0") : 52,
        Character("1") : 53,
        Character("2") : 54,
        Character("3") : 55,
        Character("4") : 56,
        Character("5") : 57,
        Character("6") : 58,
        Character("7") : 59,
        Character("8") : 60,
        Character("9") : 61,
        Character("+") : 62,
        Character(" ") : 63
        ]

    func toBlock(_ input: String, blocklen: Int = 4) -> [Int] {
        var intermediate = input
        if input.count % blocklen != 0  {
            for _ in 1...(input.count % blocklen) {
                intermediate += " "
            }
        }
        var subs = Array<String>()
        for i in 1...(intermediate.count / blocklen) {
            subs.append(String(intermediate.prefix(blocklen)))
            intermediate.removeFirst(blocklen)
        }

        var result = Array<Int>()

        for i in subs {
            var temp = i
            var blockresult = 0
            for n in 1...blocklen  {
                let number = fromBase[temp.first!]!
                blockresult += number * Int(pow(Double(64), Double(blocklen - n)))
                temp.removeFirst()
            }
            result.append(blockresult)
        }
        return result
    }

    func toText(_ input: Array<Int>, blocklen: Int = 4) -> String{
        var result = ""
        for i in input {
            var temp = i
            for n in 1...blocklen {
                let devisor = Int(pow(Double(64), Double(blocklen - n)))
                var number = Int(floor(Double(temp / devisor)))
                temp = temp - (Int(number) * devisor)
                result.append(toBase[number] ?? Character(" "))
            }
        }
        return result
    }
}
