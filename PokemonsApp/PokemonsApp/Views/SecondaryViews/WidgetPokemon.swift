//
//  WidgetPokemon.swift
//  PokemonsApp
//
//  Created by Apetrei Mirel on 28.10.23.
//

import SwiftUI

enum WidgetSize {
    case small, medium, large
}

struct WidgetPokemon: View {

    // MARK: - PROPERTIES
    @EnvironmentObject var pokemon: Pokemon
    let widgetSize: WidgetSize

    var body: some View {
        ZStack {
            Color(pokemon.types![0].capitalized)
            //                .ignoresSafeArea()

            switch widgetSize {

            case .small:

                FetchedImage(url: pokemon.sprite)

            case .medium:

                HStack {
                    FetchedImage(url: pokemon.sprite)

                    VStack(alignment: .leading) {
                        Text(pokemon.name!.capitalized)
                            .font(.title)
                            .shadow(color: .white, radius: 5)

                        Text(pokemon.types!.joined(separator: ", ").capitalized)
                            .font(.title2)

                    } // HStack
                    .padding(.trailing, 20)
                } // VStack

            case .large:
                FetchedImage(url: pokemon.sprite)

                VStack {
                    HStack {
                        Text(pokemon.name!.capitalized)
                            .font(.largeTitle)
                        Spacer()
                    } // HStack

                    Spacer()

                    HStack {
                        Spacer()
                        
                        Text(pokemon.types!.joined(separator: ", ").capitalized)
                            .font(.title2)
                    } // HStack
                } // VStack
                .padding()
            }
        }
    }
}

#Preview {
    WidgetPokemon( widgetSize: .large)
        .environmentObject(SamplePokemon.samplePokemon)
}
