//
//  SharedDataManager.swift
//  iCrave
//
//  Created by Kevin Kim on 13/11/2019.
//  Copyright © 2019 Kevin Kim. All rights reserved.
//

import Foundation
import Intents

class SharedDataManager {
    
    static let sharedManager = SharedDataManager()
    static let sharedSuiteName = "group.com.kevinkim.iCrave"
    
    let userDefaults  = UserDefaults(suiteName: sharedSuiteName)
    
    func findCategory(category: String?, with completion: ([INPerson]) -> Void) {
        
    }
    
    func saveCategory(categories: [Category]) {
        let categoryTitles = categories.map({ (category: Category) in return category.title! })
        userDefaults?.set(categoryTitles, forKey: "category")
        userDefaults?.synchronize()
    }
    
    func getAllCategory() -> [String] {
        return userDefaults?.value(forKey: "category") as? [String] ?? []
    }
}
