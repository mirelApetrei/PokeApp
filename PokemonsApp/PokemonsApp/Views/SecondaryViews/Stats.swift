//
//  Stats.swift
//  PokemonsApp
//
//  Created by Apetrei Mirel on 28.10.23.
//

import SwiftUI
import Charts

struct Stats: View {
    // MARK: - PROPERTIES
    @EnvironmentObject var pokemon: Pokemon

    var body: some View {
        Chart(pokemon.stats) { stats in
            BarMark(
                x: .value("Value", stats.value),
                y: .value("Stat", stats.label)
            )
            .annotation(position: .trailing) {
                Text("\(stats.value)")
                    .padding(.top, -5)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .padding(.horizontal, 2)

            }
        }
        .frame(height: 220)
        .padding([.leading, .bottom, .trailing])
        .foregroundColor(Color(pokemon.types![0].capitalized))
        .chartXScale(domain: 0...pokemon.higerStat.value+6)
    }
}

#Preview {
    Stats()
        .environmentObject(SamplePokemon.samplePokemon)
}
