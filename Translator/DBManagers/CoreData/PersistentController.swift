//
//  CoreDataStack.swift
//  Translator
//
//  Created by Amankeldi Zhetkergen on 23.01.2026.
//

import CoreData

final class PersistentController {
    static let shared = PersistentController()
    let container: NSPersistentContainer
    var context: NSManagedObjectContext { container.viewContext }
    
    private init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "CDTranslation")
        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }
        
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved Core Data error: \(error), \(error.userInfo)")
            }
        }
        
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
    func saveContext() {
        let context = container.viewContext
        guard context.hasChanges else { return }
        do { try context.save() }
        catch {
            let error = error as NSError
            fatalError("Unresolved Core Data save error: \(error), \(error.userInfo)")
        }
    }
}
