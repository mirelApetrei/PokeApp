//
//  TempPokemon.swift
//  PokemonsApp
//
//  Created by Apetrei Mirel on 26.10.23.
//

import Foundation

struct TempPokemon: Codable {
    let id: Int
    let name: String
    let types: [String]
    var hp: Int = 0
    var attack: Int = 0
    var defense: Int = 0
    var specialAttack: Int = 0
    var specialDefense: Int = 0
    var speed: Int = 0
    let sprite: URL
    let shiny: URL

    enum PokemonKeys: String, CodingKey {
        case id
        case name
        case types
        case stats
        case sprites

        enum TypeDictionaryKeys: String, CodingKey {
            case type

            enum TypeKeys: String, CodingKey {
                case name
            }
        }

        enum StatDictionaryKeys: String, CodingKey {
            case value = "base_stat"
            case stat

            enum StatKeys: String, CodingKey {
                case name
            }
        }

        enum SpriteKeys: String, CodingKey {
            case sprite = "front_default"
            case shiny = "front_shiny"
        }
    }

    /// This initializer is used to decode a Pokemon object from a JSON response.
    /// - Parameter decoder: The decoder object that decodes the JSON response.
    /// - Throws: An error if any values are missing or if types do not match.
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: PokemonKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)

        var decodedTypes: [String] = []

        var typesContainer = try container.nestedUnkeyedContainer(forKey: .types)
        while !typesContainer.isAtEnd {
            let typesDictionaryContainer = try typesContainer.nestedContainer(keyedBy: PokemonKeys.TypeDictionaryKeys.self)
            let typeContainer = try typesDictionaryContainer.nestedContainer(keyedBy: PokemonKeys.TypeDictionaryKeys.TypeKeys.self, forKey: .type)

            let type = try typeContainer.decode(String.self, forKey: .name)
            decodedTypes.append(type)
        }
        types = decodedTypes

        var statsContainer = try container.nestedUnkeyedContainer(forKey: .stats)

        while !statsContainer.isAtEnd {
            let statsDictionaryContainer = try statsContainer.nestedContainer(keyedBy: PokemonKeys.StatDictionaryKeys.self)
            let statContainer = try statsDictionaryContainer.nestedContainer(keyedBy: PokemonKeys.StatDictionaryKeys.StatKeys.self, forKey: .stat)

            let statName = try statContainer.decode(String.self, forKey: .name)
            let statValue = try statsDictionaryContainer.decode(Int.self, forKey: .value)

            switch try statContainer.decode(String.self, forKey: .name) {
            case "hp" :
                hp = try statsDictionaryContainer.decode(Int.self, forKey: .value)
            case "attack" :
                attack = try statsDictionaryContainer.decode(Int.self, forKey: .value)
            case "defense" :
                defense = try statsDictionaryContainer.decode(Int.self, forKey: .value)
            case "special-attack" :
                specialAttack = try statsDictionaryContainer.decode(Int.self, forKey: .value)
            case "special-defense" :
                specialDefense = try statsDictionaryContainer.decode(Int.self, forKey: .value)
            case "speed" :
                speed = try statsDictionaryContainer.decode(Int.self, forKey: .value)
            default:
                print("He will never get here ....")
            }
        }

        let spriteContainer = try container.nestedContainer(keyedBy: PokemonKeys.SpriteKeys.self, forKey: .sprites)
        sprite = try spriteContainer.decode(URL.self, forKey: .sprite)
        shiny = try spriteContainer.decode(URL.self, forKey: .shiny)
    }
}
