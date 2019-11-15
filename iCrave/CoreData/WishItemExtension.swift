//
//  WishItemExtension.swift
//  iCrave
//
//  Created by Kevin Kim on 15/11/2019.
//  Copyright © 2019 Kevin Kim. All rights reserved.
//

import CoreData

extension WishItem {
    
    public static func create(name: String, price: Decimal, currency: String, saving: Bool, image: Data?) {
        let item = WishItem(context: SharedCoreData.shared.context)
        item.name = name
        item.price = price as NSDecimalNumber
        item.currency = currency
        item.saving = saving
        item.image = image
        item.achieved = false
        item.timestamp = Date()
        SharedCoreData.shared.saveContext()
    }
    
    public static func checkAnySavingOn() -> Bool {
        let items: [WishItem] = getAll()
        for item in items {
            if item.saving {
                return true
            }
        }
        return false
    }
    
    public static func getAll() -> [WishItem] {
        var items: [WishItem] = []
        let fetchReq: NSFetchRequest<WishItem> = WishItem.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "timestamp", ascending: false)
        fetchReq.sortDescriptors = [sortDescriptor]
        do {
            items = try SharedCoreData.shared.context.fetch(fetchReq)
        } catch let error as NSError {
            print("Error occurred when getting all categories: \(error.localizedDescription)")
        }
        return items
    }
    
    public static func deleteAll() {
        let fetchReq: NSFetchRequest<NSFetchRequestResult> = WishItem.fetchRequest()
        let delReq = NSBatchDeleteRequest(fetchRequest: fetchReq)
        do {
            try SharedCoreData.shared.context.execute(delReq)
            SharedCoreData.shared.saveContext()
        } catch let error as NSError {
            print("Error occurred when deleting all categories: \(error.localizedDescription)")
        }
    }
    
}
