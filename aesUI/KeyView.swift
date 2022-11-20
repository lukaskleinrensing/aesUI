//
//  KeyView.swift
//  aesUI
//
//  Created by Philipp Dumke on 20.11.22.
//

import SwiftUI

struct KeyView: View {
    
    
    
    @EnvironmentObject var model: Model
    var body: some View {
        VStack {
            Spacer()
            Text("Rundenschlüssel")
                .font(.title)
            
            
            Text("w\(self.model.roundCount*4): \(Key.getBytesForWord(self.model.key.generateRoundKey(round: model.roundCount + 1)[0])[0]) \(Key.getBytesForWord(self.model.key.generateRoundKey(round: model.roundCount + 1)[0])[1]) \(Key.getBytesForWord(self.model.key.generateRoundKey(round: model.roundCount + 1)[0])[2]) \(Key.getBytesForWord(self.model.key.generateRoundKey(round: model.roundCount + 1)[0])[3])")
            
            Text("w\(self.model.roundCount*4+1): \(Key.getBytesForWord(self.model.key.generateRoundKey(round: model.roundCount + 1)[1])[0]) \(Key.getBytesForWord(self.model.key.generateRoundKey(round: model.roundCount + 1)[1])[1]) \(Key.getBytesForWord(self.model.key.generateRoundKey(round: model.roundCount + 1)[1])[2]) \(Key.getBytesForWord(self.model.key.generateRoundKey(round: model.roundCount + 1)[1])[3])")
            
            Text("w\(self.model.roundCount*4+2): \(Key.getBytesForWord(self.model.key.generateRoundKey(round: model.roundCount + 1)[2])[0]) \(Key.getBytesForWord(self.model.key.generateRoundKey(round: model.roundCount + 1)[2])[1]) \(Key.getBytesForWord(self.model.key.generateRoundKey(round: model.roundCount + 1)[2])[2]) \(Key.getBytesForWord(self.model.key.generateRoundKey(round: model.roundCount + 1)[2])[3])")
            
            Text("w\(self.model.roundCount*4+3): \(Key.getBytesForWord(self.model.key.generateRoundKey(round: model.roundCount + 1)[3])[0]) \(Key.getBytesForWord(self.model.key.generateRoundKey(round: model.roundCount + 1)[3])[1]) \(Key.getBytesForWord(self.model.key.generateRoundKey(round: model.roundCount + 1)[3])[2]) \(Key.getBytesForWord(self.model.key.generateRoundKey(round: model.roundCount + 1)[3])[3])")
            
//            ForEach( model.roundKeys, id: \.self){ key in
//                Text(key)
//                    .font(.system(size: 15))
//            }

            Spacer()

        }
    }
}

struct KeyView_Previews: PreviewProvider {
    static var previews: some View {
        KeyView()
    }
}
