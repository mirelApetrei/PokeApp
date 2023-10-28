//
//  PokemonViewModel.swift
//  PokemonsApp
//
//  Created by Apetrei Mirel on 27.10.23.
//

import Foundation

@MainActor
class PokemonViewModel: ObservableObject {
    enum Status {
        case notStarted
        case fetching
        case success
        case failed(error: Error)
    }

    @Published private(set) var status: Status = .notStarted
    private let controller: FetchController

    init(controller: FetchController ) {
        self.controller = controller

        Task {
            await getPokemon()
        }
    }

    /// This function is used to fetch all Pokemon from the API.
    /// It first sets the status to fetching, then tries to fetch all Pokemon.
    /// If the Pokemon are already fetched, it prints a message and sets the status to success.
    /// If the Pokemon are not fetched, it sorts them by id and saves each Pokemon to the database.
    /// After saving all Pokemon, it sets the status to success.
    /// If there is an error during the process, it sets the status to failed and prints the error.
    private  func getPokemon() async {
        status = .fetching

        do {
            guard var pokedex = try await controller.fetchAllPokemon() else {
                print("Pokemon already fetched , we have pokemon in the database")
                status = .success
                return
            }
            pokedex.sort { $0.id < $1.id }

            for pokemon in pokedex {
                let newPokemon = Pokemon(context: PersistenceController.shared.container.viewContext)
                newPokemon.id = Int16(pokemon.id)
                newPokemon.name = pokemon.name
                newPokemon.types = pokemon.types
                newPokemon.organizeTypes()
                newPokemon.hp = Int16(pokemon.hp)
                newPokemon.attack = Int16(pokemon.attack)
                newPokemon.defense = Int16(pokemon.defense)
                newPokemon.specialAttack = Int16(pokemon.specialAttack)
                newPokemon.specialDefense = Int16(pokemon.specialDefense)
                newPokemon.speed = Int16(pokemon.speed)
                newPokemon.sprite = pokemon.sprite
                newPokemon.shiny = pokemon.shiny
                newPokemon.favorite = false

                try PersistenceController.shared.container.viewContext.save()
            }
            status = .success
        } catch {
            status = .failed(error: error)
        }
    }
}
