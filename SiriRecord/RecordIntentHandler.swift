//
//  RecordIntentHandler.swift
//  iCrave
//
//  Created by Kevin Kim on 13/11/2019.
//  Copyright © 2019 Kevin Kim. All rights reserved.
//

import Foundation
import CoreData
import Intents

class RecordIntentHandler : NSObject, RecordIntentHandling {
    
    func handle(intent: RecordIntent, completion: @escaping (RecordIntentResponse) -> Void) {
        let category = categoryGetObject(title: intent.category!)!
        let currency = SharedUserDefaults.shared.getCurrency()
        recordCreate(in: category, timestamp: Date(), amount: intent.amount!.decimalValue, currency: currency)
        completion(RecordIntentResponse.success(result: "Successfully"))
    }
    
    func resolveAmount(for intent: RecordIntent, with completion: @escaping (RecordAmountResolutionResult) -> Void) {
        if let amount = intent.amount {
            if Int(truncating: amount) > 0 {
                completion(RecordAmountResolutionResult.success(with: Double(truncating: amount)))
            }
            else {
                completion(RecordAmountResolutionResult.needsValue())
            }
        }
        else {
            completion(RecordAmountResolutionResult.needsValue())
        }
    }
    
    func resolveCategory(for intent: RecordIntent, with completion: @escaping (INStringResolutionResult) -> Void) {
        if let category = intent.category {
            if category.count > 0 && category != "category" {
                let categories = categoryGetAll().map({ (category: Category) in return category.title! })
                if categories.contains(category) {
                    completion(INStringResolutionResult.success(with: category))
                }
                else {
                    completion(INStringResolutionResult.needsValue())
                }
            }
            else {
                completion(INStringResolutionResult.needsValue())
            }
        }
        else {
            completion(INStringResolutionResult.needsValue())
        }
    }
    
    // MARK: - Core Data Manipulation
    
    func categoryGetObject(title: String) -> Category? {
        var category: Category? = nil
        let fetchReq: NSFetchRequest<Category> = Category.fetchRequest()
        fetchReq.predicate = NSPredicate(format: "title = %@", title)
        do {
            let categories = try self.persistentContainer.viewContext.fetch(fetchReq)
            if categories.count > 0 {
                category = categories[0]
            }
        } catch let error as NSError {
            print("Error occurred when deleting category \(title): \(error.localizedDescription)")
        }
        return category
    }
    
    func categoryGetAll() -> [Category] {
        var categories: [Category] = []
        let fetchReq: NSFetchRequest<Category> = Category.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "title", ascending: true, selector: #selector(NSString.caseInsensitiveCompare))
        fetchReq.sortDescriptors = [sortDescriptor]
        do {
            categories = try self.persistentContainer.viewContext.fetch(fetchReq)
        } catch let error as NSError {
            print("Error occurred when getting all categories: \(error.localizedDescription)")
        }
        return categories
    }
    
    func recordCreate(in category: Category, timestamp: Date, amount: Decimal, currency: String) {
        let record = Record(context: self.persistentContainer.viewContext)
        record.timestamp = timestamp
        record.amount = amount as NSDecimalNumber
        record.currency = currency
        category.addToRecord(record)
        self.saveContext()
    }
    
    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSCustomPersistentContainer(name: "iCrave")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
}
