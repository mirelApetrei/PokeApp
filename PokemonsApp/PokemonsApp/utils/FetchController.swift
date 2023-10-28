//
//  FetchController.swift
//  PokemonsApp
//
//  Created by Apetrei Mirel on 26.10.23.
//

import Foundation
import CoreData

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
    func fetchAllPokemon() async throws -> [TempPokemon]? {
        // Check if we already have Pokemon in the database.
        if havePokemon() {
            return nil
        }
        // if there are no pokemon in the database, fetch them from the API
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

/// Fetch Single Pokemon Function
/// This function fetches a single Pokemon from a given URL.
/// It uses URLSession.shared.data to fetch the data and then decodes it into a TempPokemon object.
/// If the HTTP response status code is not 200, it throws a NetworkError.badResponse error.
/// It also prints the fetched Pokemon's id and name.
/// - Parameter url: The URL from which to fetch the Pokemon.
/// - Returns: The fetched TempPokemon object.
/// - Throws: NetworkError.badResponse if the HTTP response status code is not 200.
private func fetchPokemon(from url: URL) async throws -> TempPokemon {
    let (data, response) = try await URLSession.shared.data(from: url)

    guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
        throw NetworkError.badResponse
    }

    let tempPokemon = try JSONDecoder().decode(TempPokemon.self, from: data)

    print("Fetched \(tempPokemon.id): \(tempPokemon.name)")

    return tempPokemon
}

    /// This function checks if the user has already fetched the Pokemon from the API.
    /// It creates a new background context and fetches the Pokemon with IDs 1 and 386.
    /// If both Pokemon are found, it returns true. If not, or if there is an error, it returns false.
    private func havePokemon() -> Bool {
        let context = PersistenceController.shared.container.newBackgroundContext()

        let fetchRequest: NSFetchRequest<Pokemon> = Pokemon.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id IN %@", [1, 386])

        do {
            let checkPokemon = try context.fetch(fetchRequest)

            if checkPokemon.count == 2 {
                return true
            }
        } catch {
            print("Error fetching Pokemon: \(error)")
            return false
        }

        return false
    }

}

