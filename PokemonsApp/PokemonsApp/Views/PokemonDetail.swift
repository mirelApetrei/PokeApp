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
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject var pokemon: Pokemon
    @State var showShiny = false

    var body: some View {
        ScrollView {
            ZStack {
                Image(pokemon.background)
                    .resizable()
                    .scaledToFit()
                    .shadow(color: .black, radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
                AsyncImage(url: showShiny ? pokemon.shiny : pokemon.sprite) { image in
                    image
                        .resizable()
                        .scaledToFit()
                        .padding(.top, 60)
                        .shadow(color: .black, radius: 10)
                } placeholder: {
                    ProgressView()
                }
            }
            HStack {
                ForEach(pokemon.types!, id: \.self) { type in
                    Text(type.capitalized)
                        .font(.title2)
                        .shadow(color: .white, radius: 2)
                        .padding([.horizontal, .vertical], 8)
                        .padding([.leading, .trailing], 4)
                        .background(Color(type.capitalized))
                        .cornerRadius(50)

                }
                Spacer()

                Button {
                    withAnimation {
                        pokemon.favorite.toggle()

                        do {
                            try viewContext.save()
                        } catch {

                            let nsError = error as NSError
                            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
                        }
                    }
                } label: {
                    if pokemon.favorite {
                        Image(systemName: "star.fill")
                    } else {
                        Image(systemName: "star")
                    }
                }
                .font(.largeTitle)
                .foregroundColor(.yellow)
            }
            .padding()

            Text("Stats")
                .font(.title)
                .padding(.bottom, -7)
            Stats()
                .environmentObject(pokemon)

        }
        .navigationTitle(pokemon.name!.capitalized)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    showShiny.toggle()
                }, label: {
                    if showShiny {
                        Image(systemName: "wand.and.stars")
                            .foregroundColor(.yellow)
                    } else {
                        Image(systemName: "wand.and.stars.inverse")

                    }
                })
            }
        }
    }
}

#Preview {
     PokemonDetail()
        .environmentObject(SamplePokemon.samplePokemon)
}
