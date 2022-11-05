//
//  Extension_Array.swift
//  aesUI
//
//  Created by Philipp Dumke on 04.11.22.
//

import Foundation

extension Array<Unicode.UTF8.CodeUnit> {
    func uft8CodePointsToSting() -> String {
        var newString = ""
        _ = transcode(self.makeIterator(), from: UTF8.self, to: UTF32.self, stoppingOnError: true, into: {
            newString.append(String(Unicode.Scalar($0)!))
        })
        return newString
    }
}
