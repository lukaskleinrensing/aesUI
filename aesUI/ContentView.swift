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
                Button(action: {}, label: {Text("loadMatrix")})
            }
            HStack {
                VStack(alignment: .leading){
                    Text("Codepoints:")
                    Text(self.model.array.description)
                }
                Spacer()
                Button(action: {}, label: {Text("encrypt")})
                Button(action: {}, label: {Text("decrpyt")})
            }
            HStack {
                MatrixView()
                    .frame(width: geo.size.width * 0.5)
                Spacer()
                VStack {
                    Image(systemName: "arrow.down")
                    Text("round Key")
                    Image(systemName: "arrow.down")
                    Text("Sub Byte")
                    Image(systemName: "arrow.down")
                    Text("Shift Rows")
                    Image(systemName: "arrow.down")
                    Text("Mix Columns")
                    Image(systemName: "arrow.down")
                    Text("Key")
                }
                .font(.title)
                .frame(width: geo.size.width * 0.2)
                VStack {
                    Button(action: {
                        self.model.testmove()
                    }, label: {Text("Step")})
                    Text("roundkey:")
                    Text("          ")
                    Spacer()
                }
                .frame(width: geo.size.width * 0.2)
            }
            TextField("Key", text: self.$model.key)
            TextField("Result:", text: self.$model.result)

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
