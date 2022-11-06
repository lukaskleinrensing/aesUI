//
//  StateView.swift
//  aesUI
//
//  Created by Philipp Dumke on 06.11.22.
//

import SwiftUI

struct StateView: View {
    
    @EnvironmentObject var model: Model
    
    var body: some View {
        VStack {
            VStack {
                StateElement(name: "Klartext", state: Model.operationState.plaintext)
                Image(systemName: self.model.encrypt ? "arrow.down" : "arrow.up")
                StateElement(name: "Rundenschlüssel", state: Model.operationState.roundKey)
                Image(systemName: self.model.encrypt ? "arrow.down" : "arrow.up")
                StateElement(name: "Sub Byte", state: Model.operationState.subByte)
                Image(systemName: self.model.encrypt ? "arrow.down" : "arrow.up")
                StateElement(name: "Shift Rows", state: Model.operationState.shiftRows)
                Image(systemName: self.model.encrypt ? "arrow.down" : "arrow.up")
                StateElement(name: "Mix Columns", state: Model.operationState.mixColumns)
                Image(systemName: self.model.encrypt ? "arrow.down" : "arrow.up")
                
            }
            VStack {
                StateElement(name: "Key", state: Model.operationState.key)
                Image(systemName: self.model.encrypt ? "arrow.down" : "arrow.up")
                StateElement(name: "Chiffrat", state: Model.operationState.ciphertext)
            }
        }
        .font(.title)
    }
}

struct StateElement: View {
    @EnvironmentObject var model: Model
    var name: String
    var state: Model.operationState

    var body: some View {
        if model.state == self.state {
            Text(name)
                .frame(width: 200)
                .font(.system(size: 20))
                .foregroundColor(.primary)
                .background(RoundedRectangle(cornerRadius: 20).fill(model.isCalculating ? Color.red : Color.gray))
        } else {
            Text(name)
                .font(.system(size: 15))
                .frame(width: 200)
                .foregroundColor(Color.gray)
        }


    }
}

//struct StateView_Previews: PreviewProvider {
//    static var previews: some View {
////        StateView(true)
//    }
//}
