//
//  MatrixView.swift
//  aesUI
//
//  Created by Philipp Dumke on 05.11.22.
//

import SwiftUI

struct MatrixView: View {
    @EnvironmentObject var model: Model

    var body: some View {
        GeometryReader{ geo in
            ZStack {
                RoundedRectangle(cornerRadius: 10).fill(Color.gray)
                VStack{
                    ForEach(0..<self.model.gridSize){ rowIndex in
                        HStack{
                            ForEach(0..<self.model.gridSize){ columnIndex in
                                ZStack{
                                    RoundedRectangle(cornerRadius: 10).fill((rowIndex + columnIndex) % 2 == 1 ? Color(.green) : Color(.orange) ).transition(.identity)
                                    Text(model.descritiveValue(column: columnIndex, row: rowIndex))
                                        .font(.title)
                                        .foregroundColor(.black)
                                }
                                
                            }
                        }
                    }
                }
                .padding(5)
            }
        }
    }
}


struct MatrixView_Previews: PreviewProvider {
    static var previews: some View {
        MatrixView()
    }
}
