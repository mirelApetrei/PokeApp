//
//  ContentView.swift
//  PokemonsApp
//
//  Created by Apetrei Mirel on 26.10.23.
//

import SwiftUI
import CoreData
// Added a comment for the first time

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Pokemon.id, ascending: true)],
        animation: .default)
    private var pokedex: FetchedResults<Pokemon>

    var body: some View {
        NavigationView {
            List {
                ForEach(pokedex) { pokemon in
                    NavigationLink {
                        Text(" \(pokemon.id): \(pokemon.name!.capitalized)")
                    } label: {
                        Text(" \(pokemon.id): \(pokemon.name!.capitalized)")
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
            }
            Text("Select an item")
        }
    }
}


#Preview {
    ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
