//
//  BlockSupplantHelper.swift
//  aesUI
//
//  Created by Lukas Kleinrensing on 05.11.22.
//

import Foundation

struct BlockSupplantHelper {
    
    
    
    static let subMatrix: [[UInt8]] = [
        [1,0,0,0,1,1,1,1],
        [1,1,0,0,0,1,1,1],
        [1,1,1,0,0,0,1,1],
        [1,1,1,1,0,0,0,1],
        [1,1,1,1,1,0,0,0],
        [0,1,1,1,1,1,0,0],
        [0,0,1,1,1,1,1,0],
        [0,0,0,1,1,1,1,1]
    ]
    
    static let subInvMatrix: [[UInt8]] = [
        [0,0,1,0,0,1,0,1],
        [1,0,0,1,0,0,1,0],
        [0,1,0,0,1,0,0,1],
        [1,0,1,0,0,1,0,0],
        [0,1,0,1,0,0,1,0],
        [0,0,1,0,1,0,0,1],
        [1,0,0,1,0,1,0,0],
        [0,1,0,0,1,0,1,0]
    ]
    
    static func getSubBlockFor(_ block: UInt8) throws -> UInt8 {
        
        let blockBinary = MatrixHelper.intAsBinaryArray(block)
        let blockMultSubBlock: [UInt8]
        do {
            try blockMultSubBlock = MatrixHelper.multiplyMatrixWithVectorMod(matrix: subMatrix, vector: blockBinary, modul: 2)
        } catch {
            throw MatrixError.IncompatibleMultiplicationError
        }
        
        let subedBlock =  MatrixHelper.binaryArrayAsInt(blockMultSubBlock) ^ 198
        
        return subedBlock
    }
    
    static func getInvSubBlockFor(_ block: UInt8) throws -> UInt8 {
        let blockBinary = MatrixHelper.intAsBinaryArray(block)
        let blockMultSubBlock: [UInt8]
        do {
            try blockMultSubBlock = MatrixHelper.multiplyMatrixWithVectorMod(matrix: subInvMatrix, vector: blockBinary, modul: 2)
        } catch {
            throw MatrixError.IncompatibleMultiplicationError
        }
        
        let subedBlock =  MatrixHelper.binaryArrayAsInt(blockMultSubBlock) ^ 160
        
        return subedBlock
    }
}

enum MatrixError: Error {
    case IncompatibleMultiplicationError // Multiplication of two incompatible Matrics, ecp. 4x4 * 1x3
}
