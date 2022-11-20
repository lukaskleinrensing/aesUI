//
//  Key.swift
//  aesUI
//
//  Created by Lukas Kleinrensing on 20.11.22.
//

import Foundation

struct Key {
    
    
    
    let typ = KeyType.bit128
    let initWords: [UInt32]
    var wordsAsString: String {
        var string = "["
        
        for i in 0..<initWords.count {
            string = string + "\(initWords[i]) "
        }
        
        return string + "]"
    }
    
    
    static func getBytesForWord(_ word: UInt32) -> [UInt8] {
        var w = word
        var result: [UInt8] = [0, 0, 0, 0]

        for i in 0...3 {
            result[3 - i] = UInt8(w % 256)
            
            w = w / 256
        }

        return result
    }
    
    func generateRconForRound(_ round: Int, startRcon: UInt8) -> UInt8 {
        
        var rconJ = startRcon
        
        if (round > 0) {
            for _ in 0..<round {
                rconJ = UInt8((2 * Int(rconJ)) % 256)
            }
        }
        
        return rconJ
    }
    
    func generateRoundKeyForRound(_ round: Int, startRcon: UInt8) -> [UInt32] {
        
        func g(_ word: UInt32) -> UInt32 {
            
            // STEP ONE - one-byte left rotation
            
            let leftByte: UInt32 = word / 16777216
            var result = ((word % 16777216) * 256) + leftByte
            
            // STEP TWO - sub ech byte
            
            var resultAsArray = [UInt8]()
            var resultAsBinaryArray = [String]()
            print("Result: \(String(result, radix: 2)))")
            
            for _ in 0...3 {
                resultAsArray.append(UInt8(result % 256))
                resultAsBinaryArray.append(String(result % 256, radix: 2))
                result = result / 256
            }
            
            print("Result as binary array: \(resultAsBinaryArray)")
            
            do {
                try result = UInt32(BlockSupplantHelper.getSubBlockFor(resultAsArray[3]))
                print("SubBlock for \(resultAsArray[3]): \(result)")
                
                for i in 1...3 {
                    result = result * 256
                    try result += UInt32(BlockSupplantHelper.getSubBlockFor(resultAsArray[3 - i]))
                    try print("SubBlock for \(resultAsArray[3-i]): \(String(BlockSupplantHelper.getSubBlockFor(resultAsArray[3 - i]), radix: 2))")
                }
            } catch { return word } //TODO: Throw error
            
            print("Result after substitution: \(String(result, radix: 2))")

            // STEP THREE - xor with rcon
            
            let rcon = self.generateRconForRound(round, startRcon: startRcon)
            
            result = (UInt32(rcon) * 16777216) ^ result
            
            return result
        }
        
        var wi = self.initWords[0]
        var wiPlus1 = self.initWords[1]
        var wiPlus2 = self.initWords[2]
        var wiPlus3 = self.initWords[3]
        
        if(round > 0) {
            for _ in 0..<round {
                let wiPlus4 = wiPlus1 ^ g(wi)
                let wiPlus5 = wiPlus4 ^ wiPlus1
                let wiPlus6 = wiPlus5 ^ wiPlus2
                let wiPlus7 = wiPlus6 ^ wiPlus3
                
                wi = wiPlus4
                wiPlus1 = wiPlus5
                wiPlus2 = wiPlus6
                wiPlus3 = wiPlus7
            }
        }
        
        return [wi, wiPlus1, wiPlus2, wiPlus3]
    }
    
}

enum KeyType {
    case bit128
    case bit192
    case bit256
}
