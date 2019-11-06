//
//  Dummy.swift
//  iCrave
//
//  Created by Kevin Kim on 22/10/2019.
//  Copyright © 2019 Kevin Kim. All rights reserved.
//

import Foundation
import UIKit

func loadDummyCategories() {
    Category.deleteAll()
    let categories: [String:String] = [
        "Food": "red",
        "Octopus": "orange",
        "Supermarket": "yellow",
        "School": "green",
        "Club": "blue",
        "Furniture": "purple",
        "Shopping": "pink",
        "Vacation": "teal",
        "Hobby": "indigo",
        "Gambling": "gray",
        "Secret": "black",
        "Charity": "white"
    ]
    
    for category in categories {
        Category.create(title: category.key, color: category.value)
    }
}

func loadDummyRecords() {
    Record.deleteAll()
    
    let records: [String:[Any]] = [
        "Food": ["2019-1-2", 500, "HKD"],
        "Octopus": ["2019-1-3", 200, "HKD"],
        "Supermarket": ["2019-1-4", 300, "HKD"],
        "School": ["2019-1-5", 2000, "HKD"],
        "Club": ["2019-1-6", 3000, "HKD"],
        "Furniture": ["2019-1-7", 6000, "HKD"],
        "Shopping": ["2019-1-8", 500, "HKD"],
        "Vacation": ["2019-1-9", 10000, "HKD"],
        "Hobby": ["2019-1-10", 4000, "HKD"],
        "Gambling": ["2019-1-11", 500, "HKD"],
        "Secret": ["2019-1-12", 100, "HKD"],
        "Charity": ["2019-1-13", 600, "HKD"]
    ]
    
    for record in records {
        if let category = Category.getObject(title: record.key) {
            Record.create(in: category, timestamp: dateMaker(record.value[0] as! String), amount: Decimal(record.value[1] as! Int), currency: record.value[2] as! String)
        }
    }
}

func dateMaker(_ string: String) -> Date {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd"
    return formatter.date(from: string)!
}
