//
//  TileView.swift
//  aesUI
//
//  Created by Philipp Dumke on 05.11.22.
//

import SwiftUI

struct BlockView: View {
    @EnvironmentObject var model: Model
    let block: Block
    var isMarked: Bool {
        return model.selectedBlocks.contains(block.id)
    }

    var body: some View {
        ZStack{
            if self.isMarked {
                RoundedRectangle(cornerRadius: 10)
                    .fill(.red)
            } else {
                RoundedRectangle(cornerRadius: 10)
            }
            Text(block.text)
                .font(.title)
                .foregroundColor(.black)
        }
        .onTapGesture {
            if model.selectedBlocks.contains(block.id) {
                model.selectedBlocks.remove(block.id)
            }else {
                model.selectedBlocks.insert(block.id)
            }
        }
        
    }
}

struct TileView_Previews: PreviewProvider {
    static var previews: some View {
        BlockView(block: Block(UInt8(5)))
    }
}
