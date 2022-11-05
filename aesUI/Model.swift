//
//  Model.swift
//  aesUI
//
//  Created by Philipp Dumke on 05.11.22.
//

import Foundation
import SwiftUI

class Model: ObservableObject {

    var gridSize: Int = 4
    @Published var text: String
    @Published var array: Array<String.UTF8View.Element> {
        willSet {
            objectWillChange.send()
        }
    }
    @Published var key: String = ""
    @Published var result: String = ""

    init(text: String = "") {
        self.text = text
        self.array = "abcdefghijklmnop".returnByteRepresentation()

    }

    func testmove() {
        withAnimation() {
            array.insert(contentsOf: "Z".utf8, at: 5)
            array = array.dropLast(1)

        }
    }
    
    func descritiveValue(column: Int, row: Int) -> String {

        var index = 0
        switch column {
        case 0:
            index = row;
        case 1:
            index = 4 + row;
        case 2:
            index = 8 + row;
        default:
            index = 12 + row;

        }
        print("for column: \(column) row: \(row):  \(index)")
        return array[index].description
    }
}
