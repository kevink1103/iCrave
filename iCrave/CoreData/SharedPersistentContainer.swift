//
//  SharedPersistentContainer.swift
//  iCrave
//
//  Created by Kevin Kim on 13/11/2019.
//  Copyright © 2019 Kevin Kim. All rights reserved.
//

import CoreData

class SharedPersistentContainer: NSPersistentContainer {
    
    override class func defaultDirectoryURL() -> URL {
        var storeURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.com.kevinkim.iCrave")
        storeURL = storeURL?.appendingPathComponent("iCrave.sqlite")
        return storeURL!
    }
    
    lazy var defaultContext: NSManagedObjectContext = {
        let coordinator = self.persistentStoreCoordinator
        var defaultContext = NSManagedObjectContext(concurrencyType: NSManagedObjectContextConcurrencyType.mainQueueConcurrencyType)
        defaultContext.persistentStoreCoordinator = coordinator
        defaultContext.mergePolicy = NSMergePolicy(merge: NSMergePolicyType.mergeByPropertyObjectTrumpMergePolicyType);
        return defaultContext
    }()
    
}
