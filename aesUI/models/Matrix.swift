//
//  Matrix.swift
//  aesUI
//
//  Created by Lukas Kleinrensing on 04.11.22.
//

import Foundation

struct Matrix {
    
    /*
     
    This object represents a Matrix used in the AES-algorithem.
    The cells of the matrix are numbers as following:
     
    128-Bit
    +--+--+--+--+
    |b0|b4|b8|bC|
    +--+--+--+--+
    |b1|b5|b9|bD|
    +--+--+--+--+
    |b2|b6|bA|bE|
    +--+--+--+--+
    |b3|b7|bB|bF|
    +--+--+--+--+
    */
    
    var blocks = [Block]()
    let typ: MatrixType
    
    func getTyp() -> MatrixType {
        return self.typ
    }
    
    func validate() {
        //TODO: Funktion zur Überprüfung der eigenen Integrität (z.B. passende Anzahl an Blocks für Bit-Typ)
    }
    
    func asConsoleString() -> String {
        let s = """
        +--+--+--+--+
        |\(self.blocks[0].value)|\(self.blocks[4])|\(self.blocks[8])|\(self.blocks[12])|
        +--+--+--+--+
        |\(self.blocks[1])|\(self.blocks[5])|\(self.blocks[9])|\(self.blocks[13])|
        +--+--+--+--+
        |\(self.blocks[2])|\(self.blocks[6])|\(self.blocks[10])|\(self.blocks[14])|
        +--+--+--+--+
        |\(self.blocks[3])|\(self.blocks[7])|\(self.blocks[11])|\(self.blocks[15])|
        +--+--+--+--+
        """
        
        return s
    }
    
    mutating func updateBlocks(_ newBlocks: [UInt8]) {
        
        for j in 0..<self.blocks.count {
            self.blocks[j].value = newBlocks[j]
        }
    }
    
    mutating func subBits() throws {
        var newBlocks = [UInt8]()
        
        for i in 0...(self.blocks.count - 1) {
            try newBlocks[i] = BlockSupplantHelper.getSubBlockFor(self.blocks[i].value)
        }
        
        updateBlocks(newBlocks)
        
    }
    
    mutating func subBitsInvers() throws{
        var newBlocks = [UInt8]()
        
        for i in 0...(self.blocks.count - 1) {
            try newBlocks[i] = BlockSupplantHelper.getInvSubBlockFor(self.blocks[i].value)
        }
        
        updateBlocks(newBlocks)
    }
    
    mutating func shiftRows() {
        var newBlocks = [UInt8]()
        
        let n = self.blocks.count
        
        for _ in 1...n {
            newBlocks.append(UInt8())
        }
        
        
        for o in 0...3 {
            // Shift row 0 : 0->3
            for r in 0...((n / 4) - 1) {
                newBlocks[((r*4+(o*1))+(n-(o*4))) % n] = self.blocks[r*4+(o*1)].value
            }
        }
        
        updateBlocks(newBlocks)
    }
    
    mutating func shiftRowsInvers() {
        var newBlocks = [UInt8]()
        
        let n = self.blocks.count
        
        for _ in 1...n {
            newBlocks.append(UInt8())
        }
        
        for o in 0...3 {
            // Shift Row 1
            for r in 0...((n / 4) - 1) {
                newBlocks[r*4+(o*1)] = self.blocks[((r*4+(o*1))+(n-(o*4))) % n].value
            }
        }
        
        updateBlocks(newBlocks)
    }
    
    mutating func mixColums() {
        
        var result = [UInt8]()
        
        for i in 0...(self.blocks.count - 1) {
            result.append(UInt8())
        }
        
        let m: [[UInt8]] = [
        [2,3,1,1],
        [1,2,3,1],
        [1,1,2,3],
        [3,1,1,2]
        ]
        
        for i in 0..<(blocks.count/4) {
            
            var vector = [UInt8]()
            
            vector.append(self.blocks[(i * 1 + 0) % self.blocks.count].value)
            vector.append(self.blocks[(i * 1 + 4) % self.blocks.count].value)
            vector.append(self.blocks[(i * 1 + 8) % self.blocks.count].value)
            vector.append(self.blocks[(i * 1 + 12) % self.blocks.count].value)
            
            var newColum = [UInt8]()
                    
            do {
                try newColum = MatrixHelper.multiplyMatrixWithVectorMod(matrix: m, vector: vector, modul: 256)
            } catch {
                //TODO:
            }
            
            result[(i * 1 + 0) % self.blocks.count] = newColum[0]
            result[(i * 1 + 4) % self.blocks.count] = newColum[1]
            result[(i * 1 + 8) % self.blocks.count] = newColum[2]
            result[(i * 1 + 12) % self.blocks.count] = newColum[3]
            
        }
        
        updateBlocks(result)
    }

    mutating func mixColumsInv() {
        
        var result = [UInt8]()
        
        for _ in 0...(self.blocks.count - 1) {
            result.append(UInt8())
        }
        
        let m: [[UInt8]] = [
    //    [2,3,1,1],
    //    [14,11,13,9],
    //    [9,14,11,13],
    //    [11,13,9,14]
    //    ]
            [212, 161, 7, 59],
            [59, 212, 161, 7],
            [7, 59, 212, 161],
            [161, 7, 59, 212]
            ]
        
        for i in 0..<(self.blocks.count/4) {
            
            var vector = [UInt8]()
            
            vector.append(self.blocks[(i * 1 + 0) % self.blocks.count].value)
            vector.append(self.blocks[(i * 1 + 4) % self.blocks.count].value)
            vector.append(self.blocks[(i * 1 + 8) % self.blocks.count].value)
            vector.append(self.blocks[(i * 1 + 12) % self.blocks.count].value)
            
            var newColum = [UInt8]()
            
            
            do {
                try newColum = MatrixHelper.multiplyMatrixWithVectorMod(matrix: m, vector: vector, modul: 256)
            } catch {
                //TODO:
            }
            
            result[(i * 1 + 0) % self.blocks.count] = newColum[0]
            result[(i * 1 + 4) % self.blocks.count] = newColum[1]
            result[(i * 1 + 8) % self.blocks.count] = newColum[2]
            result[(i * 1 + 12) % self.blocks.count] = newColum[3]
            
        }
        
        updateBlocks(result)
    }
}

struct MatrixHelper {
    
    static func multiplyMatrixWithVector(matrix: [[UInt8]], vector: [UInt8]) throws -> [UInt8] {
        
        // Check compatibility of matrix and vector
        
        let m0Count = matrix[0].count
        
        if (m0Count != vector.count) {
            throw MatrixError.IncompatibleMultiplicationError
        }
        
        for m in 1..<matrix.count {
            if matrix[m].count != m0Count {
                throw MatrixError.IncompatibleMultiplicationError
            }
        }
        
        // Calculate product matrixs
        
        var restultMatrix = [UInt8]()
        for n in 0..<m0Count {
            restultMatrix.append(UInt8(n))
        }
        
        for i in 0..<matrix.count {
            print("i: \(i)")
            var rowResult: UInt8 = 0
            
            for j in 0..<matrix.count {
                print(" j: \(j)")
                rowResult += matrix[i][j] * vector[j]
            }
            restultMatrix[i] = rowResult
        }
        
        return restultMatrix
    }
    
    static func multiplyMatrixWithVectorMod(matrix: [[UInt8]], vector: [UInt8], modul: Int) throws -> [UInt8] {
        
        // Check compatibility of matrix and vector
        
        let m0Count = matrix[0].count
        
        if (m0Count != vector.count) {
            throw MatrixError.IncompatibleMultiplicationError
        }
        
        for m in 1..<matrix.count {
            if matrix[m].count != m0Count {
                throw MatrixError.IncompatibleMultiplicationError
            }
        }
        
        // Calculate product matrixs
        
        var resultMatrix = [UInt8]()
        for n in 0..<matrix.count {
            resultMatrix.append(UInt8(n))
        }
        
        for i in 0..<matrix.count {
            print("i: \(i)")
            var rowResult: UInt8 = 0
            
            for j in 0..<m0Count {
                print(" j: \(j)")
                let rowResultAsInt = Int(rowResult + (matrix[i][j] * vector[j]))
                rowResult = UInt8(rowResultAsInt % modul)
            }
            resultMatrix[i] = rowResult
        }
        
        return resultMatrix
    }
    
    static func intAsBinaryArray(_ i: UInt8, minLength: Int = 0, lastReturn: Bool = true) -> [UInt8] {
    
        var result = [UInt8]()
        
        if(i > 0) {
            result.append(UInt8(i % 2))
            if (i/2 > 0) {
                result = intAsBinaryArray((i / 2), lastReturn: false) + result
            }
        }
        
        if lastReturn {
            while (result.count < 8) {
                result = [UInt8(0)] + result
            }
        }
        
        return result
    }
    
    static func binaryArrayAsInt(_ a: [UInt8]) -> UInt8 {

        var result: UInt8 = 0
        
        for i in 0..<a.count {
            result += UInt8(powl(2, Double(a.count - (i+1)))) * a[i]
        }
        
        return result
    }
}

enum MatrixType {
    case bit128
    case bit192
    case bit256
}
