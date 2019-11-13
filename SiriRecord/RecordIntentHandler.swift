//
//  RecordIntentHandler.swift
//  iCrave
//
//  Created by Kevin Kim on 13/11/2019.
//  Copyright © 2019 Kevin Kim. All rights reserved.
//

import Foundation
import Intents

class RecordIntentHandler : NSObject, RecordIntentHandling {
    
    func handle(intent: RecordIntent, completion: @escaping (RecordIntentResponse) -> Void) {
        print(intent.amount!)
        print(intent.category!)
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
                let categories = SharedDataManager.sharedManager.getAllCategory()
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
    
}
