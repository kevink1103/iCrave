//
//  CategoryExtension.swift
//  iCrave
//
//  Created by Kevin Kim on 22/10/2019.
//  Copyright © 2019 Kevin Kim. All rights reserved.
//

import CoreData

extension Category {
    
    public static func create(title: String, color: String) {
        let category = Category(context: SharedCoreData.shared.context)
        category.title = title
        category.color = color
        SharedCoreData.shared.saveContext()
    }
    
    public static func getObject(title: String) -> Category? {
        var category: Category? = nil
        let fetchReq: NSFetchRequest<Category> = Category.fetchRequest()
        fetchReq.predicate = NSPredicate(format: "title = %@", title)
        do {
            let categories = try SharedCoreData.shared.context.fetch(fetchReq)
            if categories.count > 0 {
                category = categories[0]
            }
        } catch let error as NSError {
            print("Error occurred when deleting category \(title): \(error.localizedDescription)")
        }
        return category
    }

    public static func getAll() -> [Category] {
        var categories: [Category] = []
        let fetchReq: NSFetchRequest<Category> = Category.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "title", ascending: true, selector: #selector(NSString.caseInsensitiveCompare))
        fetchReq.sortDescriptors = [sortDescriptor]
        do {
            categories = try SharedCoreData.shared.context.fetch(fetchReq)
        } catch let error as NSError {
            print("Error occurred when getting all categories: \(error.localizedDescription)")
        }
        return categories
    }
    
    public static func update(category: Category, title: String, color: String) {
        category.title = title
        category.color = color
        SharedCoreData.shared.saveContext()
    }
    
    public static func delete(title: String) {
        if let category: Category = getObject(title: title) {
            SharedCoreData.shared.context.delete(category)
            SharedCoreData.shared.saveContext()
        } else {
            print("Category \(title) does not exist")
        }
    }
    
    public static func delete(category: Category) {
        SharedCoreData.shared.context.delete(category)
        SharedCoreData.shared.saveContext()
    }

    public static func deleteAll() {
        let fetchReq: NSFetchRequest<NSFetchRequestResult> = Category.fetchRequest()
        let delReq = NSBatchDeleteRequest(fetchRequest: fetchReq)
        do {
            try SharedCoreData.shared.context.execute(delReq)
            SharedCoreData.shared.saveContext()
        } catch let error as NSError {
            print("Error occurred when deleting all categories: \(error.localizedDescription)")
        }
    }
}
