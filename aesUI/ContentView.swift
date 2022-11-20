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
    
    enum infoMode {
        case Key, Calculation
    }
    @State var infoState = infoMode.Key

    var matrixSizeMultiplyer: CGFloat {
        let blockCount = model.matrixBlockCount / 4

        if blockCount == 4 {
            return 0.5
        }
        if blockCount == 6 {
            return 0.6
        }
        return 0.65
    }
    
    var body: some View {
        GeometryReader { geo in
        VStack {
            HStack {
                TextField(self.model.encrypt ? "Klartext" : "Chiffrat", text: self.$model.text)
                    .font(.system(size: 20))
                    .onSubmit {
                        if (self.model.array.blocks.count == 0) {
                            self.model.textToMatrix()
                            self.model.state = self.model.encrypt ? .roundKey : .key
                            self.model.loadStartKeys()
                        } else {
                            if(self.model.result.isEmpty) {
                                self.model.nextState()
                                print("next step")
                            } else {
                                self.showingAlert.toggle()
                            }
                        }
                    }

            }
            HStack {
                VStack{
                    MatrixView()
                        .padding()
                        .frame(width: geo.size.width * matrixSizeMultiplyer)
                    Slider(value: $model.animationSpeed, in: 0...10)
                    Text("AnimationSpeed \(model.animationSpeed, specifier: "%.1f") Sekunden")
                }
                Spacer()
                VStack {
                    Picker("", selection: $model.selectedBitType) {
                        Text("128 Bit").tag(MatrixType.bit128)
                        Text("192 Bit").tag(MatrixType.bit192)
                        Text("256 Bit").tag(MatrixType.bit256)
                        
                    }.pickerStyle(SegmentedPickerStyle())
                        .padding(.trailing)
                        .frame(width: geo.size.width * 0.3)

                    
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
                                    self.model.nextState()
                                }, label:{
                                    Image(systemName: "forward.fill")
                                        .padding()
                                        .background(Circle()
                                        .fill(self.model.array.blocks.count > 0 ? Color.blue : Color.gray))
                                }).disabled(self.model.array.blocks.count == 0 || !self.model.result.isEmpty)
                                Button(action: {self.model.encrypt.toggle()
                                    self.model.state = self.model.encrypt ? .plaintext : .ciphertext
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
                                    .alert("Es werden alle aktuellen Werte und Ergebnisse gelöscht. Fortfahren?", isPresented: $showingAlert) {
                                        Button("Okay") {self.showingAlert = false
                                            self.model.resetApp()} //TODO: Implement reseting matrix and roundCount }
                                        Button(action: {self.showingAlert = false}, label: {Text("Cancel").foregroundColor(.red)})
                                }
                            }
                        }

//                        VStack (alignment: .trailing){
//                            Button(action: model.textToMatrix, label: {Text("loadMatrix").frame(width: 100)})
//                                .buttonStyle(.bordered)
//                            Button(action: {}, label: {Text("encrypt").frame(width: 100)})
//                                .buttonStyle(.bordered)
//                            Button(action: {}, label: {Text("decrpyt").frame(width: 100)})
//                                .buttonStyle(.bordered)
//                            Button(action: {}, label: {Text("Step").frame(width: 100)})
//                            .buttonStyle(.bordered)
//
//                            VStack (alignment: .trailing){
//                                Text("Debug Buttons")
//                                    .padding(.top)
//                                Button(action: model.nextState, label: {Text("nextState").frame(width:100)})
//                                Button(action: model.resetState, label: {Text("resetState").frame(width:100)})
//                                Button(action: model.testmove, label: {Text("moveTiles").frame(width:100)})
//                                Button(action: model.matrixToText , label: {Text("matrixToResult").frame(width:100)})
//                            }
//                        }

                    }
                    Spacer()

                    Picker("", selection: self.$infoState) {
                        Text("Rundenschlüssel").tag(infoMode.Key)
                        Text("Berechnungen").tag(infoMode.Calculation)
                    }.pickerStyle(SegmentedPickerStyle())
                        .padding(.trailing)
                        .frame(width: geo.size.width * 0.3)
                        .padding()

                    if(infoState == infoMode.Key) {
                        KeyView()
                            .frame(width: geo.size.width * 0.4, height: geo.size.height * 0.3)
                            .padding()
                    } else {
                        CalcMixColumnsView()
                            .frame(width: geo.size.width * 0.4, height: geo.size.height * 0.3)
                            .padding()
                    }
                }

            }
            TextField(self.model.encrypt ? "Chiffrat" : "Klartext", text: self.$model.result)
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
