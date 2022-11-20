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
        GeometryReader { geo in
            HStack {
                Spacer()
                VStack {
                    
                    VStack {
                        Text("Startrundenschlüssel")
                            .font(.title)
                        HStack{
                            Text("w0")
                            TextField("", text: self.$model.w0)
                                .disabled(self.model.array.blocks.count != 0)
                                .frame(width: geo.size.width / 5)
                        }
                        HStack{
                            Text("w1")
                            TextField("", text: self.$model.w1)
                                .disabled(self.model.array.blocks.count != 0)
                                .frame(width: geo.size.width / 5)
                        }
                        HStack{
                            Text("w2")
                            TextField("", text: self.$model.w2)
                                .disabled(self.model.array.blocks.count != 0)
                                .frame(width: geo.size.width / 5)
                        }
                        HStack{
                            Text("w3")
                            TextField("", text: self.$model.w3)
                                .disabled(self.model.array.blocks.count != 0)
                                .frame(width: geo.size.width / 5)
                        }
                    }
                    Spacer()
                    Text("Aktueller Rundenschlüssel")
                        .font(.title)
                    
                    
                    Text("w\(self.model.roundCount*4): \(Key.getBytesForWord(self.model.key.generateRoundKey(round: self.model.encrypt ? (self.model.roundCount + 1) : ((self.model.maxRounds - self.model.roundCount) + 1))[0])[0]) \(Key.getBytesForWord(self.model.key.generateRoundKey(round: self.model.encrypt ? (self.model.roundCount + 1) : ((self.model.maxRounds - self.model.roundCount) + 1))[0])[1]) \(Key.getBytesForWord(self.model.key.generateRoundKey(round: self.model.encrypt ? (self.model.roundCount + 1) : ((self.model.maxRounds - self.model.roundCount) + 1))[0])[2]) \(Key.getBytesForWord(self.model.key.generateRoundKey(round: self.model.encrypt ? (self.model.roundCount + 1) : ((self.model.maxRounds - self.model.roundCount) + 1))[0])[3])")
                    
                    Text("w\(self.model.roundCount*4+1): \(Key.getBytesForWord(self.model.key.generateRoundKey(round: self.model.encrypt ? (self.model.roundCount + 1) : ((self.model.maxRounds - self.model.roundCount) + 1))[1])[0]) \(Key.getBytesForWord(self.model.key.generateRoundKey(round: self.model.encrypt ? (self.model.roundCount + 1) : ((self.model.maxRounds - self.model.roundCount) + 1))[1])[1]) \(Key.getBytesForWord(self.model.key.generateRoundKey(round: self.model.encrypt ? (self.model.roundCount + 1) : ((self.model.maxRounds - self.model.roundCount) + 1))[1])[2]) \(Key.getBytesForWord(self.model.key.generateRoundKey(round: self.model.encrypt ? (self.model.roundCount + 1) : ((self.model.maxRounds - self.model.roundCount) + 1))[1])[3])")
                    
                    Text("w\(self.model.roundCount*4+2): \(Key.getBytesForWord(self.model.key.generateRoundKey(round: self.model.encrypt ? (self.model.roundCount + 1) : ((self.model.maxRounds - self.model.roundCount) + 1))[2])[0]) \(Key.getBytesForWord(self.model.key.generateRoundKey(round: self.model.encrypt ? (self.model.roundCount + 1) : ((self.model.maxRounds - self.model.roundCount) + 1))[2])[1]) \(Key.getBytesForWord(self.model.key.generateRoundKey(round: self.model.encrypt ? (self.model.roundCount + 1) : ((self.model.maxRounds - self.model.roundCount) + 1))[2])[2]) \(Key.getBytesForWord(self.model.key.generateRoundKey(round: self.model.encrypt ? (self.model.roundCount + 1) : ((self.model.maxRounds - self.model.roundCount) + 1))[2])[3])")
                    
                    Text("w\(self.model.roundCount*4+3): \(Key.getBytesForWord(self.model.key.generateRoundKey(round: self.model.encrypt ? (self.model.roundCount + 1) : ((self.model.maxRounds - self.model.roundCount) + 1))[3])[0]) \(Key.getBytesForWord(self.model.key.generateRoundKey(round: self.model.encrypt ? (self.model.roundCount + 1) : ((self.model.maxRounds - self.model.roundCount) + 1))[3])[1]) \(Key.getBytesForWord(self.model.key.generateRoundKey(round: self.model.encrypt ? (self.model.roundCount + 1) : ((self.model.maxRounds - self.model.roundCount) + 1))[3])[2]) \(Key.getBytesForWord(self.model.key.generateRoundKey(round: self.model.encrypt ? (self.model.roundCount + 1) : ((self.model.maxRounds - self.model.roundCount) + 1))[3])[3])")
                    
                    //            ForEach( model.roundKeys, id: \.self){ key in
                    //                Text(key)
                    //                    .font(.system(size: 15))
                    //            }
                    
                    Spacer()
                    
                }
                Spacer()
            }
        }
    }
}

struct KeyView_Previews: PreviewProvider {
    static var previews: some View {
        KeyView()
    }
}
