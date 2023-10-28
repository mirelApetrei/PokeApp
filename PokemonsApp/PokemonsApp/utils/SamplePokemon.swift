//
//  SamplePokemon.swift
//  PokemonsApp
//
//  Created by Apetrei Mirel on 27.10.23.
//

import Foundation
import CoreData

/// Struct for SamplePokemon
struct SamplePokemon {

   /// Static variable for samplePokemon
   static let samplePokemon = {

       /// Context for PersistenceController
       let context = PersistenceController.preview.container.viewContext

       /// Fetch request for Pokemon
       let fetchRequest: NSFetchRequest<Pokemon> = Pokemon.fetchRequest()
       fetchRequest.fetchLimit = 1

       /// Results from fetch request
       let results = try! context.fetch(fetchRequest)

       /// Return first result
       return results.first!
   }()
}
