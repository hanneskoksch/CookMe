//
//  PersistenceController.swift
//  CookMe
//
//  Created by Torben Ziegler on 19.05.21.
//

import CoreData

// Controller for database
struct PersistenceController {
    
    // accessing instance of core data
    static let shared = PersistenceController()
    
    /*
     Simplifies the creation and management of the Core Data stack by handling the creation of the managed object model, persistent store coordinator, and the managed object context
     */
    let container: NSPersistentContainer
    
    init() {
        // Creating container to save data in database "CookMe"
        container = NSPersistentContainer(name: "CookMe")
        // Loads the persistent stores
        container.loadPersistentStores { (description, error) in
            if let error = error {
                fatalError("Error: \(error.localizedDescription)")
            }
        }
    }
    
    // Saves an object to the database
    func save(completion: @escaping (Error?) -> () = {_ in}) {
        let context = container.viewContext
        if context.hasChanges {
            do {
                try context.save()
                completion(nil)
            } catch {
                completion(error)
            }
        }
    }
    
    // Deletes an object from the database
    func delete(_ object: NSManagedObject, completion: @escaping (Error?) -> () = {_ in}) {
        let context = container.viewContext
        context.delete(object)
        save(completion: completion)
    }
    
}
