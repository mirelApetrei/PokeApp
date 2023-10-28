//
//  ContentView.swift
//  PokemonsApp
//
//  Created by Apetrei Mirel on 26.10.23.
//

import SwiftUI
import CoreData

struct ContentView: View {

    // MARK: - PROPERTIES
  
    @State var filterByFavorites = false
    @StateObject private var pokemonVM = PokemonViewModel(controller: FetchController())

    // MARK: - Properties wrapers
    /// FetchRequest is a property wrapper type that can drive views from the results of a fetch request.
    /// The sortDescriptors argument is used to sort the fetched results.
    /// The animation argument is used to animate changes in the fetched results.
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Pokemon.id, ascending: true)],
        animation: .default
    ) private var pokedex: FetchedResults<Pokemon>

    /// FetchRequest is a property wrapper type that can drive views from the results of a fetch request.
    /// The sortDescriptors argument is used to sort the fetched results.
    /// The predicate argument is used to filter the fetched results.
    /// The animation argument is used to animate changes in the fetched results.
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Pokemon.id, ascending: true)],
        predicate: NSPredicate(format: "favorite == %d",  true),
        animation: .default
    ) private var favorites: FetchedResults<Pokemon>

    var body: some View {

        switch pokemonVM.status {
        case .success:
            NavigationStack {
                List(filterByFavorites ? favorites : pokedex) { pokemon in
                    NavigationLink(value: pokemon) {
                        AsyncImage(url: pokemon.sprite!) { image in
                            image
                                .resizable()
                                .scaledToFit()
                        } placeholder: {
                            ProgressView()
                        }
                        .frame(width: 100, height: 100)

                        Text(pokemon.name!.capitalized)

                        if pokemon.favorite {
                            Spacer()
                            Image(systemName: "star.fill")
                                .foregroundColor(.yellow)
                        }
                    } // NavigationLink
                } // List
                .navigationTitle("Pokedex")
                .navigationDestination(for: Pokemon.self, destination: { pokemon in
                   PokemonDetail()
                        .environmentObject(pokemon)
                })
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            withAnimation {
                                filterByFavorites.toggle()
                            }
                        } label: {
                            Label("Filter By Favorites", systemImage:  filterByFavorites ? "star.fill" : "star")
                        } // label
                        .font(.largeTitle)
                        .foregroundColor(.yellow)
                    }
                } // toolbar

            } // NavigationStack
            default:
                ProgressView()
        } // switch
    } // body
}


#Preview {
    ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
