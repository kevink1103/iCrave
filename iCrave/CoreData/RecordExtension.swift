//
//  RecordExtension.swift
//  iCrave
//
//  Created by Kevin Kim on 24/10/2019.
//  Copyright © 2019 Kevin Kim. All rights reserved.
//

import UIKit
import CoreData

// UNTESTED!!!

extension Record {
    
    public static func create(in category: Category, timestamp: Date, amount: Decimal, currency: String) {
        let record = Record(context: CoreDataManager.context)
        record.timestamp = timestamp
        record.amount = amount as NSDecimalNumber
        record.currency = currency
        category.addToRecord(record)
        do {
            try CoreDataManager.context.save()
        } catch let error as NSError {
           print("Error occurred when saving record: \(error.localizedDescription)")
        }
    }
    
    public static func getAll() -> [Record] {
        var records: [Record] = []
        let fetchReq: NSFetchRequest<Record> = Record.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "timestamp", ascending: false)
        fetchReq.sortDescriptors = [sortDescriptor]
        do {
            records = try CoreDataManager.context.fetch(fetchReq)
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
    
    public static func update(record: Record, timestamp: Date, amount: Decimal, currency: String) {
        record.timestamp = timestamp
        record.amount = amount as NSDecimalNumber
        record.currency = currency
        do {
            try CoreDataManager.context.save()
        } catch let error as NSError {
            print("Error occurred when updating record: \(error.localizedDescription)")
        }
    }
    
    public static func delete(in category: Category, record: Record) {
        category.removeFromRecord(record)
        do {
            try CoreDataManager.context.save()
        } catch let error as NSError {
            print("Error occurred when deleting record: \(error.localizedDescription)")
        }
    }
    
    public static func deleteAll() {
        let fetchReq: NSFetchRequest<NSFetchRequestResult> = Record.fetchRequest()
        let delReq = NSBatchDeleteRequest(fetchRequest: fetchReq)
        do {
            try CoreDataManager.context.execute(delReq)
            try CoreDataManager.context.save()
        } catch let error as NSError {
            print("Error occurred when deleting all records: \(error.localizedDescription)")
        }
    }

    public static func deleteAll(in category: Category) {
        if let categoryRecords = category.record {
            category.removeFromRecord(categoryRecords)
        }
        do {
            try CoreDataManager.context.save()
        } catch let error as NSError {
            print("Error occurred when deleting all records in \(category.title!): \(error.localizedDescription)")
        }
    }
}
