//
//  PokemonDetailView.swift
//  PokemonsApp
//
//  Created by Apetrei Mirel on 27.10.23.
//

import SwiftUI
import CoreData

struct PokemonDetail: View {

    // MARK: - Properties
    @EnvironmentObject var pokemon: Pokemon

    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
     PokemonDetail()
        .environmentObject(SamplePokemon.samplePokemon)
}
