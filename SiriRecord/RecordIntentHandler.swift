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
        let category = Category.getObject(title: intent.category!)!
        let currency = SharedUserDefaults.shared.getCurrency()
        Record.create(in: category, timestamp: Date(), amount: intent.amount!.decimalValue, currency: currency)
        completion(RecordIntentResponse.success(result: "successfully"))
    }
    
    func provideCategoryOptions(for intent: RecordIntent, with completion: @escaping ([String]?, Error?) -> Void) {
        let categories = Category.getAll().map({ (category: Category) in return category.title! })
        completion(categories, nil)
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
            if category.count > 0 && category != "Category" {
                let categories = Category.getAll().map({ (category: Category) in return category.title! })
                for categoryTitle in categories {
                    if category.lowercased() == categoryTitle.lowercased() {
                        completion(INStringResolutionResult.success(with: categoryTitle))
                        return
                    }
                }
                completion(INStringResolutionResult.needsValue())
            }
            else {
                completion(INStringResolutionResult.needsValue())
            }
        }
        else {
            completion(INStringResolutionResult.needsValue())
        }
    }
    
}
