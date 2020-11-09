//
//  UserStorageManager.swift
//  App
//
//  Created by MAC HOME on 11/6/20.
//  Copyright © 2020 JORELCRUZ. All rights reserved.
//

import UIKit
import CoreData

class UserStorageManger {
    
    let persistentContainer: NSPersistentContainer!
    
    //MARK: Init with dependency
    init(container: NSPersistentContainer) {
        self.persistentContainer = container
        self.persistentContainer.viewContext.automaticallyMergesChangesFromParent = true
    }
    
    lazy var backgroundContext: NSManagedObjectContext = {
        return self.persistentContainer.newBackgroundContext()
    }()
    
    lazy var mainContext: NSManagedObjectContext = {
        return self.persistentContainer.viewContext
    }()
    
    
    // MARK: - Core Data Saving support
    func save(with context: NSManagedObjectContext) {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                if nserror.code == 133021 {
                    log_error(message: nserror.localizedDescription)
                } else {
                    fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
                }
            }
        } else {
            log_Warning(message: "no chan ges")
        }
    }
    
}
