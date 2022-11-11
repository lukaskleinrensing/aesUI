//
//  Extension_Sting.swift
//  aesUI
//
//  Created by Philipp Dumke on 04.11.22.
//

import Foundation

extension String {

    func returnByteRepresentation() -> Array<String.UTF8View.Element> {
        return Array(self.utf8)
    }
    var id: UUID {
        return UUID()
    }


}
