//
//  FetchController.swift
//  PokemonsApp
//
//  Created by Apetrei Mirel on 26.10.23.
//

import Foundation

struct FetchController {

    enum NetworkError: Error {
        case badURL, badResponse, badData
    }
// MARK: - Variables and Computed properties
    private let baseURL = URL(string: "https://pokeapi.co/api/v2/pokemon/")!

// MARK: - Fetch All Pokemon Function
    /// This function fetches all Pokemon from the API.
    /// It first constructs the URL with a query limit of 386.
    /// Then it sends a request to the API and checks the response status code.
    /// If the status code is 200, it proceeds to parse the JSON data into a dictionary.
    /// It then loops through the dictionary and fetches each Pokemon's details.
    /// Finally, it returns an array of all fetched Pokemon.
    func fetchAllPokemon() async throws -> [TempPokemon] {
        var allPokemon: [TempPokemon] = []

        var fetchComponents = URLComponents(url: baseURL, resolvingAgainstBaseURL: true)
        fetchComponents?.queryItems = [
            URLQueryItem(name: "limit", value: "386")
        ]

        guard let fetchURL = fetchComponents?.url else {
            throw NetworkError.badURL
        }

        let (data, response) = try await URLSession.shared.data(from: fetchURL)

        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw NetworkError.badResponse
        }

        guard let pokeDictionary = try JSONSerialization.jsonObject(with: data) as? [String: Any], let pokedex = pokeDictionary["results"] as? [[String: String]] else {
            throw NetworkError.badData
        }

        for pokemon in pokedex {
            if let url = pokemon["url"] {
                allPokemon.append(try await fetchPokemon(from: URL(string: url)!))
            }
        }

        return allPokemon
    }

// MARK: - Fetch Single Pokemon Function
    private func fetchPokemon(from url: URL) async throws -> TempPokemon {
        let (data, response) = try await URLSession.shared.data(from: url)

        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw NetworkError.badResponse
        }

        let tempPokemon = try JSONDecoder().decode(TempPokemon.self, from: data)

        print("Fetched \(tempPokemon.id): \(tempPokemon.name)")

        return tempPokemon
    }

}

