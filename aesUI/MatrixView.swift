//
//  MatrixView.swift
//  aesUI
//
//  Created by Philipp Dumke on 05.11.22.
//

import SwiftUI

struct MatrixView: View {
    @EnvironmentObject var model: Model
    let rows = [
            GridItem(.flexible(minimum: 20)),
            GridItem(.flexible(minimum: 20)),
            GridItem(.flexible(minimum: 20)),
            GridItem(.flexible(minimum: 20))
        ]

    var body: some View {
        GeometryReader{ geo in
            ZStack{
                RoundedRectangle(cornerRadius: 10).fill(.gray)
                LazyHGrid(rows: rows, spacing: 10) {
                    ForEach(model.array.blocks) { block in
                        BlockView(block: block)
                            .frame(width: geo.size.width / 4 )

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
