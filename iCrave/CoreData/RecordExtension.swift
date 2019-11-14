//
//  RecordExtension.swift
//  iCrave
//
//  Created by Kevin Kim on 24/10/2019.
//  Copyright © 2019 Kevin Kim. All rights reserved.
//

import CoreData

extension Record {
    
    public static func create(in category: Category, timestamp: Date, amount: Decimal, currency: String) {
        let record = Record(context: SharedCoreData.shared.context)
        record.timestamp = timestamp
        record.amount = amount as NSDecimalNumber
        record.currency = currency
        category.addToRecord(record)
        SharedCoreData.shared.saveContext()
    }
    
    public static func getAll() -> [Record] {
        var records: [Record] = []
        let fetchReq: NSFetchRequest<Record> = Record.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "timestamp", ascending: false)
        fetchReq.sortDescriptors = [sortDescriptor]
        do {
            records = try SharedCoreData.shared.context.fetch(fetchReq)
        } catch let error as NSError {
            print("Error occurred when getting all records: \(error.localizedDescription)")
        }
        return records
    }

    public static func getAll(in category: Category) -> [Record] {
        var records: [Record] = []
        if let categoryRecords = category.record {
            records = categoryRecords.allObjects as! [Record]
        }
        return records
    }
    
    public static func getRecents() -> [Record] {
        var records: [Record] = []
        let fetchReq: NSFetchRequest<Record> = Record.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "timestamp", ascending: false)
        fetchReq.sortDescriptors = [sortDescriptor]
        fetchReq.fetchLimit = 5
        do {
            records = try SharedCoreData.shared.context.fetch(fetchReq)
        } catch let error as NSError {
            print("Error occurred when getting all records: \(error.localizedDescription)")
        }
        return records
    }
    
    public static func update(record: Record, timestamp: Date, amount: Decimal, currency: String) {
        record.timestamp = timestamp
        record.amount = amount as NSDecimalNumber
        record.currency = currency
        SharedCoreData.shared.saveContext()
    }
    
    public static func delete(in category: Category, record: Record) {
        category.removeFromRecord(record)
        SharedCoreData.shared.saveContext()
    }
    
    public static func deleteAll() {
        let fetchReq: NSFetchRequest<NSFetchRequestResult> = Record.fetchRequest()
        let delReq = NSBatchDeleteRequest(fetchRequest: fetchReq)
        do {
            try SharedCoreData.shared.context.execute(delReq)
            SharedCoreData.shared.saveContext()
        } catch let error as NSError {
            print("Error occurred when deleting all records: \(error.localizedDescription)")
        }
    }

    public static func deleteAll(in category: Category) {
        if let categoryRecords = category.record {
            category.removeFromRecord(categoryRecords)
        }
        SharedCoreData.shared.saveContext()
    }
}
