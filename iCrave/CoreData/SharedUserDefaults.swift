//
//  SharedUserDefaults.swift
//  iCrave
//
//  Created by Kevin Kim on 13/11/2019.
//  Copyright © 2019 Kevin Kim. All rights reserved.
//

import Foundation

class SharedUserDefaults {
    // MARK: - Shared UserDefaults stack
    
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
    
    func setStartDate(date: Date) {
        var dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
        dateComponents.hour! = 0
        dateComponents.minute! = 0
        dateComponents.second! = 0
        guard let newDate = Calendar.current.date(from: dateComponents) else { return }
        print(date)
        print(newDate)
        userDefaults?.set(newDate, forKey: "date")
        userDefaults?.synchronize()
    }
    
    func getStartDate() -> Date? {
        guard let date = userDefaults?.value(forKey: "date") as? Date else { return nil }
        return DataAnalyzer.applyTimezone(date)
    }
    
    func setNotification(id: String, mode: Bool) {
        userDefaults?.set(mode, forKey: id)
        userDefaults?.synchronize()
    }
    
    func getNotification(id: String) -> Bool {
        return userDefaults?.value(forKey: id) as? Bool ?? false
    }
    
    func resetAll() {
        guard let dictionary = userDefaults?.dictionaryRepresentation() else { return }
        dictionary.keys.forEach { key in
            userDefaults?.removeObject(forKey: key)
        }
        userDefaults?.synchronize()
    }
}
