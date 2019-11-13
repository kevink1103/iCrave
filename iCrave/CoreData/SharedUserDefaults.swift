//
//  SharedUserDefaults.swift
//  iCrave
//
//  Created by Kevin Kim on 13/11/2019.
//  Copyright © 2019 Kevin Kim. All rights reserved.
//

import Foundation

class SharedUserDefaults {
    static let shared = SharedUserDefaults()
    static let sharedSuiteName = "group.com.kevinkim.iCrave"

    let userDefaults = UserDefaults(suiteName: sharedSuiteName)
    
    func setBudget(budget: String) {
        userDefaults?.set(budget, forKey: "budget")
        userDefaults?.synchronize()
    }
    
    func getBudget() -> String {
        return userDefaults?.value(forKey: "budget") as? String ?? ""
    }
    
    func setCurrency(currency: String) {
        userDefaults?.set(currency, forKey: "currency")
        userDefaults?.synchronize()
    }
    
    func getCurrency() -> String {
        return userDefaults?.value(forKey: "currency") as? String ?? ""
    }
}
