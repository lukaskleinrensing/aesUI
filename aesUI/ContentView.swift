//
//  ContentView.swift
//  aesUI
//
//

import SwiftUI
import CoreData

struct ContentView: View {

    @EnvironmentObject var model: Model

    var body: some View {
        GeometryReader { geo in
        VStack {
            HStack {
                TextField("Klartext", text: self.$model.text)
                    .font(.system(size: 20))

            }
            HStack {
                MatrixView()
                    .padding()
                    .frame(width: geo.size.width * 0.5)
                Spacer()
                VStack {
                    HStack {
                        StateView()
                            .padding()

                        VStack (alignment: .trailing){
                            Button(action: {}, label: {Text("loadMatrix").frame(width: 100)})
                                .buttonStyle(.bordered)
                            Button(action: {}, label: {Text("encrypt").frame(width: 100)})
                                .buttonStyle(.bordered)
                            Button(action: {}, label: {Text("decrpyt").frame(width: 100)})
                                .buttonStyle(.bordered)
                            Button(action: {}, label: {Text("Step").frame(width: 100)})
                            .buttonStyle(.bordered)

                            Text("Debug Buttons")
                                .padding(.top)
                            Button(action: model.nextState, label: {Text("nextState").frame(width:100)})
                            Button(action: model.resetState, label: {Text("resetState").frame(width:100)})
                            Button(action: model.testmove, label: {Text("moveTiles").frame(width:100)})
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
        }

    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
