//
//  PokemonsAppApp.swift
//  PokemonsApp
//
//  Created by Apetrei Mirel on 26.10.23.
//

import SwiftUI

@main
struct PokemonsAppApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
