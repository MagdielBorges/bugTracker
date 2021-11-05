//
//  StorageProvider.swift
//  Bug Tracker
//
//  Created by Magdiel Borges on 11/4/21.
//

import Foundation
import CoreData

class StorageProvider: ObservableObject {
    let persistentContainer : NSPersistentContainer
    
    init(){
        persistentContainer = NSPersistentContainer(name: "BugTracker")
        persistentContainer.viewContext.automaticallyMergesChangesFromParent = true
        persistentContainer.viewContext.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
        persistentContainer.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Core Data store failed to load with error: \(error)")
            }
        }
    }
}

extension StorageProvider {
    func save() {
        do {
            try persistentContainer.viewContext.save()
        } catch {
            persistentContainer.viewContext.rollback()
            print("Failed to save context: \(error)")
        }
    }
    
    func delete(_ object: NSManagedObject) {
        persistentContainer.viewContext.delete(object)
        save()
    }
}
