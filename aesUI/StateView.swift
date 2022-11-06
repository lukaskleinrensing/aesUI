//
//  StateView.swift
//  aesUI
//
//  Created by Philipp Dumke on 06.11.22.
//

import SwiftUI

struct StateView: View {
    var body: some View {
        VStack {
            Image(systemName: "arrow.down")
            StateElement(name: "Rundenschlüssel", state: Model.operationState.roundKey)
            Image(systemName: "arrow.down")
            StateElement(name: "Sub Byte", state: Model.operationState.subByte)
            Image(systemName: "arrow.down")
            StateElement(name: "Shift Rows", state: Model.operationState.shiftRows)
            Image(systemName: "arrow.down")
            StateElement(name: "Mix Columns", state: Model.operationState.mixColumns)
            Image(systemName: "arrow.down")
            StateElement(name: "Key", state: Model.operationState.key)
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
                .background(RoundedRectangle(cornerRadius: 20).fill(Color.red))
        } else {
            Text(name)
                .font(.system(size: 15))
                .frame(width: 200)
                .foregroundColor(Color.gray)
        }


    }
}

struct StateView_Previews: PreviewProvider {
    static var previews: some View {
        StateView()
    }
}
