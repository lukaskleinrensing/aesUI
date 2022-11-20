//
//  MatrixView.swift
//  aesUI
//
//  Created by Philipp Dumke on 05.11.22.
//

import SwiftUI

struct MatrixView: View {

    var blockCount: Int {
        return model.matrixBlockCount / 4
    }

    @EnvironmentObject var model: Model
    let rows = [
            GridItem(.flexible(minimum: 20)),
            GridItem(.flexible(minimum: 20)),
            GridItem(.flexible(minimum: 20)),
            GridItem(.flexible(minimum: 20))
        ]

    var body: some View {
        GeometryReader { geo in
            ZStack{
                RoundedRectangle(cornerRadius: 10).fill(.gray)
                LazyHGrid(rows: rows, spacing: 10) {
                    ForEach(model.array.blocks, id: \.self) { block in
                        BlockView(block: block)
                            .frame(width: (geo.size.width / CGFloat(blockCount)) - 10 )
                            .rotation3DEffect(Angle(degrees: model.animationAmount), axis: (1,0,0))

                    }
                }
                .padding()
            }
        }
    }
}


struct MatrixView_Previews: PreviewProvider {
    static var previews: some View {
        MatrixView()
    }
}
