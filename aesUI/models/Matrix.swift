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
    
    var blocks = [Data]()
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
        |\(self.blocks[0])|\(self.blocks[4])|\(self.blocks[8])|\(self.blocks[12])|
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
    
    mutating func shiftRows() {
        var newBlocks = [Data]()
        
        let n = self.blocks.count
        
        for _ in 1...n {
            newBlocks.append(Data())
        }
        
        
        for o in 0...3 {
            // Shift row 0 : 0->3
            for r in 0...((n / 4) - 1) {
                newBlocks[((r*4+(o*1))+(n-(o*4))) % n] = self.blocks[r*4+(o*1)]
            }
        }
        
        
        self.blocks = newBlocks
    }
    
    mutating func shiftRowsInvers() {
        var newBlocks = [Data]()
        
        let n = self.blocks.count
        
        for _ in 1...n {
            newBlocks.append(Data())
        }
        
        for o in 0...3 {
            // Shift Row 1
            for r in 0...((n / 4) - 1) {
                newBlocks[r*4+(o*1)] = self.blocks[((r*4+(o*1))+(n-(o*4))) % n]
            }
        }
        
        self.blocks = newBlocks
    }
    
    func mixColums() {
        //TODO: Implementieren
    }
    
    func mixColumsInvers() {
        //TODO: Implementieren
    }
    
}

enum MatrixType {
    case bit128
    case bit192
    case bit256
}
