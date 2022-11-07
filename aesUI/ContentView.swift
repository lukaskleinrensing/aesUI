//
//  ContentView.swift
//  aesUI
//
//

import SwiftUI
import CoreData

struct ContentView: View {

    @EnvironmentObject var model: Model
    @State var showingAlert = false
    
    var body: some View {
        GeometryReader { geo in
        VStack {
            HStack {
                TextField("Klartext", text: self.$model.text)
                    .font(.system(size: 20))
                    .onSubmit {model.textToMatrix()
                        model.state = .roundKey
                    }

            }
            HStack {
                MatrixView()
                    .frame(width: geo.size.width * 0.5)
                    .padding()
                Spacer()
                VStack {
                    Picker("", selection: $model.selectedBitType) {
                        Text("128 Bit").tag(MatrixType.bit128)
                        Text("192 Bit").tag(MatrixType.bit192)
                        Text("256 Bit").tag(MatrixType.bit256)
                        
                    }.pickerStyle(SegmentedPickerStyle())
                        .frame(width: geo.size.width * 0.5)
                    
                    HStack {
                        VStack {
                            StateView()
                                .padding()
                            VStack{
                                Text("Verbleibende Runden:")
                                Text("\(model.maxRounds - model.roundCount)")
                            }
                            HStack {
                                Button(action: {self.model.nextState()
                                }, label:{
                                    Image(systemName: "play.fill")
                                        .padding()
                                        .background(Circle()
                                        .fill(self.model.array.blocks.count > 0 ? Color.blue : Color.gray))
                                }).disabled(self.model.array.blocks.count == 0 || !self.model.result.isEmpty)
                                Button(action: {
                                    while(self.model.state != (self.model.encrypt ? Model.operationState.ciphertext : Model.operationState.plaintext)) {
                                    self.model.nextState()
                                    }
                                }, label:{
                                    Image(systemName: "forward.fill")
                                        .padding()
                                        .background(Circle()
                                        .fill(self.model.array.blocks.count > 0 ? Color.blue : Color.gray))
                                }).disabled(self.model.array.blocks.count == 0 || !self.model.result.isEmpty)
                                Button(action: {self.model.encrypt.toggle()
                                }, label:{
                                    Image(systemName: self.model.encrypt ? "lock.open" : "lock")
                                        .padding()
                                        .background(Circle()
                                        .fill(Color.blue))
                                }).disabled(self.model.array.blocks.count != 0)
                                Button(action: {self.showingAlert = true
                                }, label:{
                                    Image(systemName: "trash.fill")
                                        .padding()
                                        .background(Circle()
                                        .fill(Color.red))
                                }).disabled(self.model.array.blocks.count == 0)
                                    .alert("Important message", isPresented: $showingAlert) {
                                        Button("Okay") {self.showingAlert = false} //TODO: Implement reseting matrix and roundCount }
                                        Button(action: {self.showingAlert = false}, label: {Text("Cancel").foregroundColor(.red)})
                                }
                            }
                        }

                        VStack (alignment: .trailing){
                            Button(action: model.textToMatrix, label: {Text("loadMatrix").frame(width: 100)})
                                .buttonStyle(.bordered)
                            Button(action: {}, label: {Text("encrypt").frame(width: 100)})
                                .buttonStyle(.bordered)
                            Button(action: {}, label: {Text("decrpyt").frame(width: 100)})
                                .buttonStyle(.bordered)
                            Button(action: {}, label: {Text("Step").frame(width: 100)})
                            .buttonStyle(.bordered)

                            VStack (alignment: .trailing){
                                Text("Debug Buttons")
                                    .padding(.top)
                                Button(action: model.nextState, label: {Text("nextState").frame(width:100)})
                                Button(action: model.resetState, label: {Text("resetState").frame(width:100)})
                                Button(action: model.testmove, label: {Text("moveTiles").frame(width:100)})
                                Button(action: model.matrixToText , label: {Text("matrixToResult").frame(width:100)})
                                Slider(value: $model.animationSpeed, in: 0...10)
                                Text("AnimationSpeed \(model.animationSpeed, specifier: "%.1f") Sekunden")
                            }
                        }

                    }
                    Spacer()

                    VStack {
                        Text("Rundenschlüssel:")
                            .font(.title)
                        ForEach( model.roundKeys, id: \.self){ key in
                            Text(key)
                                .font(.system(size: 15))
                        }

                    }
                }

            }
            TextField("Schlüssel", text: self.$model.key)
                .font(.system(size: 20))
            TextField("Ergebnis", text: self.$model.result)
                .font(.system(size: 20))

        }
        .padding()
        .frame(minWidth: 800, minHeight: 500)
        }

    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(Model())
            .frame(width: 800, height: 500)
    }
}
