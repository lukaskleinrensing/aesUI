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
                        }
                        .frame(width: geo.size.width / 3)
                        HStack{
                            Text("w1")
                            TextField("", text: self.$model.w1)
                                .disabled(self.model.array.blocks.count != 0)
                        }
                        .frame(width: geo.size.width / 3)
                        HStack{
                            Text("w2")
                            TextField("", text: self.$model.w2)
                                .disabled(self.model.array.blocks.count != 0)
                        }
                        .frame(width: geo.size.width / 3)
                        HStack{
                            Text("w3")
                            TextField("", text: self.$model.w3)
                                .disabled(self.model.array.blocks.count != 0)
                        }
                        .frame(width: geo.size.width / 3)
                        HStack{
                            Text("Rundenkonstante")
                            TextField("", text: self.$model.rconString)
                                .disabled(self.model.array.blocks.count != 0).onSubmit({
                                    guard let rcon = UInt8(self.model.rconString) else {
                                        //TODO: Fehlermeldung?
                                        self.model.rconString = String(self.model.rcon)
                                        
                                        return
                                    }
                                    self.model.rcon = rcon
                                })
                        }
                        .frame(width: geo.size.width / 3)
                    }
                    Spacer()
                    Text("Aktueller Rundenschlüssel")
                        .font(.title)
                    
                    
                    Text("w\(self.model.roundCount*4): \(Key.getBytesForWord(self.model.key.generateRoundKeyForRound(self.model.encrypt ? (self.model.roundCount + 1) : ((self.model.maxRounds - self.model.roundCount) + 1), startRcon: self.model.rcon)[0])[0]) \(Key.getBytesForWord(self.model.key.generateRoundKeyForRound(self.model.encrypt ? (self.model.roundCount + 1) : ((self.model.maxRounds - self.model.roundCount) + 1), startRcon: self.model.rcon)[0])[1]) \(Key.getBytesForWord(self.model.key.generateRoundKeyForRound(self.model.encrypt ? (self.model.roundCount + 1) : ((self.model.maxRounds - self.model.roundCount) + 1), startRcon: self.model.rcon)[0])[2]) \(Key.getBytesForWord(self.model.key.generateRoundKeyForRound(self.model.encrypt ? (self.model.roundCount + 1) : ((self.model.maxRounds - self.model.roundCount) + 1), startRcon: self.model.rcon)[0])[3])")

                    Text("w\(self.model.roundCount*4+1): \(Key.getBytesForWord(self.model.key.generateRoundKeyForRound(self.model.encrypt ? (self.model.roundCount + 1) : ((self.model.maxRounds - self.model.roundCount) + 1), startRcon: self.model.rcon)[1])[0]) \(Key.getBytesForWord(self.model.key.generateRoundKeyForRound(self.model.encrypt ? (self.model.roundCount + 1) : ((self.model.maxRounds - self.model.roundCount) + 1), startRcon: self.model.rcon)[1])[1]) \(Key.getBytesForWord(self.model.key.generateRoundKeyForRound(self.model.encrypt ? (self.model.roundCount + 1) : ((self.model.maxRounds - self.model.roundCount) + 1), startRcon: self.model.rcon)[1])[2]) \(Key.getBytesForWord(self.model.key.generateRoundKeyForRound(self.model.encrypt ? (self.model.roundCount + 1) : ((self.model.maxRounds - self.model.roundCount) + 1), startRcon: self.model.rcon)[1])[3])")

                    Text("w\(self.model.roundCount*4+2): \(Key.getBytesForWord(self.model.key.generateRoundKeyForRound(self.model.encrypt ? (self.model.roundCount + 1) : ((self.model.maxRounds - self.model.roundCount) + 1), startRcon: self.model.rcon)[2])[0]) \(Key.getBytesForWord(self.model.key.generateRoundKeyForRound(self.model.encrypt ? (self.model.roundCount + 1) : ((self.model.maxRounds - self.model.roundCount) + 1), startRcon: self.model.rcon)[2])[1]) \(Key.getBytesForWord(self.model.key.generateRoundKeyForRound(self.model.encrypt ? (self.model.roundCount + 1) : ((self.model.maxRounds - self.model.roundCount) + 1), startRcon: self.model.rcon)[2])[2]) \(Key.getBytesForWord(self.model.key.generateRoundKeyForRound(self.model.encrypt ? (self.model.roundCount + 1) : ((self.model.maxRounds - self.model.roundCount) + 1), startRcon: self.model.rcon)[2])[3])")

                    Text("w\(self.model.roundCount*4+3): \(Key.getBytesForWord(self.model.key.generateRoundKeyForRound(self.model.encrypt ? (self.model.roundCount + 1) : ((self.model.maxRounds - self.model.roundCount) + 1), startRcon: self.model.rcon)[3])[0]) \(Key.getBytesForWord(self.model.key.generateRoundKeyForRound(self.model.encrypt ? (self.model.roundCount + 1) : ((self.model.maxRounds - self.model.roundCount) + 1), startRcon: self.model.rcon)[3])[1]) \(Key.getBytesForWord(self.model.key.generateRoundKeyForRound(self.model.encrypt ? (self.model.roundCount + 1) : ((self.model.maxRounds - self.model.roundCount) + 1), startRcon: self.model.rcon)[3])[2]) \(Key.getBytesForWord(self.model.key.generateRoundKeyForRound(self.model.encrypt ? (self.model.roundCount + 1) : ((self.model.maxRounds - self.model.roundCount) + 1), startRcon: self.model.rcon)[3])[3])")
                    
                    Text("Aktuelle Rundenkonstante: \(self.model.key.generateRconForRound(self.model.roundCount, startRcon: self.model.rcon))")
                    
//                                ForEach( model.roundKeys, id: \.self){ key in
//                                    Text(key)
//                                        .font(.system(size: 15))
//                                }
                    
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
