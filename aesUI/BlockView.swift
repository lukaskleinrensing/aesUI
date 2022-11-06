//
//  TileView.swift
//  aesUI
//
//  Created by Philipp Dumke on 05.11.22.
//

import SwiftUI

struct BlockView: View {
    let block: Block
    var body: some View {
        ZStack{
            RoundedRectangle(cornerRadius: 10)
            Text(block.text)
                .font(.title)
                .foregroundColor(.black)
        }
        
    }
}

struct TileView_Previews: PreviewProvider {
    static var previews: some View {
        BlockView(block: Block(UInt8(5)))
    }
}
