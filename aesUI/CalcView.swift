//
//  CalcView.swift
//  aesUI
//
//  Created by Philipp Dumke on 20.11.22.
//

import SwiftUI

struct CalcMixColumnsView: View {
    @EnvironmentObject var model: Model
    let mixColumnsdata = [idInt(2),idInt(3),idInt(1),idInt(1),idInt(1),idInt(2),idInt(3),idInt(1),idInt(1),idInt(1),idInt(2),idInt(3),idInt(3),idInt(1),idInt(1),idInt(2)]
    let mixColumsdataInv = [idInt(212), idInt(161), idInt(7), idInt(59), idInt(59), idInt(212), idInt(161), idInt(7),idInt(7), idInt(59), idInt(212), idInt(161),idInt(161), idInt(7), idInt(59), idInt(212)]

    let rows = [
            GridItem(.fixed(30), spacing: 0),
            GridItem(.fixed(30), spacing: 0),
            GridItem(.fixed(30), spacing: 0),
            GridItem(.fixed(30), spacing: 0)
        ]
    let columns = [
            GridItem(.fixed(30), spacing: 5),
            GridItem(.fixed(30), spacing: 5),
            GridItem(.fixed(30), spacing: 5),
            GridItem(.fixed(30), spacing: 5)
        ]
    var body: some View {
        GeometryReader { geo in
            VStack (alignment: .center, spacing: 10){
                Text("Mix Columns")
                    .font(.title)

                HStack (spacing: 10){
Spacer()
                    VStack {
                        Text("Aktuelle Matrix")
                        LazyHGrid(rows: rows, spacing: 5) {
                            ForEach(model.array.blocks, id: \.self) { block in
                                Text(block.text)
                            }
                        }
                    }


                    Text("X")
                        .padding()

                    VStack{
                        Text("Standard Matrix)")
                        if (model.encrypt) {
                            LazyVGrid(columns: columns, spacing: 5) {
                                ForEach(mixColumnsdata ) { item in
                                    Text("\(item.value)")
                                }
                            }

                        } else {
                            LazyVGrid(columns: columns, spacing: 5) {
                                ForEach(mixColumsdataInv ) { item in
                                    Text("\(item.value)")
                                }
                            }

                        }
                    }
Spacer()
                }
                .padding()

            }
            .padding()
        }
    }
}


struct idInt: Identifiable {
    let id = UUID()
    let value: Int
    init(_ val: Int) {
        value = val
    }
}

struct openBrace: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()

        path.move(to: CGPoint(x: rect.midX * 0.2 , y: rect.minY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.midX * 0.2, y: rect.maxY))

        return path
    }
}
struct closeBrace: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()

        path.move(to: CGPoint(x: 1 - rect.midX * 0.2 , y: rect.minY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.addLine(to: CGPoint(x: 1 - rect.midX * 0.2, y: rect.maxY))

        return path
    }
}
