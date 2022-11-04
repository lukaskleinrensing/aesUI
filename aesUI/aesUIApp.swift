//
//  aesUIApp.swift
//  aesUI
//
//  Created by Lukas Kleinrensing on 04.11.22.
//

import SwiftUI

@main
struct aesUIApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
