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
    
    func generateRoundKey(round: Int) -> [UInt32] {
        
        func g(_ word: UInt32) -> UInt32 {
            return word
        }
        
        var wi = self.initWords[0]
        var wiPlus1 = self.initWords[1]
        var wiPlus2 = self.initWords[2]
        var wiPlus3 = self.initWords[3]
        
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
        
        return [wi, wiPlus1, wiPlus2, wiPlus3]
    }
    
}

enum KeyType {
    case bit128
    case bit192
    case bit256
}
