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
    let records = [
        "Food": 500,
        "Octopus": 200,
        "Supermarket": 300,
        "School": 2000,
        "Club": 3000,
        "Furniture": 6000,
        "Shopping": 500,
        "Vacation": 10000,
        "Hobby": 4000,
        "Gambling": 500,
        "Secret": 100,
        "Charity": 600
    ]
    let currency = "HKD"
    
    for record in records {
        if let category = Category.getObject(title: record.key) {
            Record.create(in: category, timestamp: Date(), amount: Decimal(record.value), currency: currency)
        }
    }
}
