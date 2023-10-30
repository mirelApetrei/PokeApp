//
//  Persistence.swift
//  PokemonsApp
//
//  Created by Apetrei Mirel on 26.10.23.
//

import CoreData

struct PersistenceController {

    // MARK: - Variables and Computed properties

    static let shared = PersistenceController() // this how you initialise a singleton
    let container: NSPersistentContainer


/// This is a preview of the PersistenceController.
/// It sets up a Pokemon object with sample data and saves it to the viewContext.
/// If the save operation fails, it throws a fatal error.
static var preview: PersistenceController = {
    let result = PersistenceController(inMemory: true)
    let viewContext = result.container.viewContext
    // set up some sample data
    let samplePokemon = Pokemon(context: viewContext)
    samplePokemon.id = 1
    samplePokemon.name = "bulbasaur"
    samplePokemon.types = ["grass", "poison"]
    samplePokemon.hp = 45
    samplePokemon.attack = 49
    samplePokemon.defense = 49
    samplePokemon.specialAttack = 65
    samplePokemon.specialDefense = 65
    samplePokemon.speed = 45
    samplePokemon.sprite = URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/1.png")
    samplePokemon.shiny = URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/shiny/1.png")
    samplePokemon.favorite = false
    do {
        try viewContext.save()
    } catch {
        let nsError = error as NSError
        fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
    }
    return result
}()

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "PokemonsApp")

        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        } else {
            container.persistentStoreDescriptions.first!.url = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.peronal.mirel.PokemonGroup")!.appending(path: "PokemonsApp.sqlite")
        }

        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
}
