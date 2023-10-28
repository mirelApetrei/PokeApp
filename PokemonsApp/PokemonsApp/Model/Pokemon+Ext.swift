//
//  Pokemon+Ext.swift
//  PokemonsApp
//
//  Created by Apetrei Mirel on 28.10.23.
//

import Foundation


/// This extension adds additional functionality to the Pokemon class.
/// It includes computed properties for background, stats, and higherStat.
extension Pokemon {

    // MARK: - Variables and Computed properties
    /// This computed property returns a string based on the Pokemon's type.
    var background: String {
        switch self.types![0] {
        case "normal", "grass", "electric", "poison", "fairy":
            return "normalgrasselectricpoisonfairy"
        case "rock", "ground", "steel", "fighting", "ghost", "dark", "psychic":
            return "rockgroundsteelfightingghostdarkpsychic"
        case "fire", "dragon":
            return "firedragon"
        case "flying", "bug":
            return "flyingbug"
        case "ice":
            return "ice"
        case "water":
            return "water"
        default:
            return "thereisnoimage"
        }
    }

    /// This computed property returns an array of Stat objects representing the Pokemon's stats.
    var stats: [Stat] {
        [
            Stat(id: 1, label: "HP", value: self.hp),
            Stat(id: 2, label: "Attack", value: self.attack),
            Stat(id: 3, label: "Defense", value: self.defense),
            Stat(id: 4, label: "Special Attack", value: self.specialAttack),
            Stat(id: 5, label: "Special Defense", value: self.specialDefense),
            Stat(id: 6, label: "Speed", value: self.speed)
        ]
    }

    /// This computed property returns the Stat with the highest value.
    var higerStat: Stat {
        stats.max { $0.value < $1.value }!
    }

 /// this function swaps the first two types if the first type is normal
    func organizeTypes() {
        if self.types!.count == 2 && self.types![0] == "normal" {
            self.types!.swapAt(0, 1)
        }
    }
}


/// This struct represents a Pokemon's stat, including its id, label, and value.
struct Stat: Identifiable {
    var id: Int
    var label: String
    var value: Int16
}
