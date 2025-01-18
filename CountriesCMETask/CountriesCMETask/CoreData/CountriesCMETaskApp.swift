//
//  CountriesCMETaskApp.swift
//  CountriesCMETask
//
//  Created by Moustafa Hegazy on 17/01/2025.
//

import SwiftUI

@main
struct CountriesCMETaskApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
