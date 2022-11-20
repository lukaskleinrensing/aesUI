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
            Text("Rundenschlüssel:")
                .font(.title)
            ForEach( model.roundKeys, id: \.self){ key in
                Text(key)
                    .font(.system(size: 15))
            }

            Spacer()

        }
    }
}

struct KeyView_Previews: PreviewProvider {
    static var previews: some View {
        KeyView()
    }
}
