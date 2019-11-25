//
//  DataAnalyzer.swift
//  iCrave
//
//  Created by Kevin Kim on 24/11/2019.
//  Copyright © 2019 Kevin Kim. All rights reserved.
//

import Foundation

class DataAnalyzer {
    static func dailyBudget(formonth date: Date) -> Decimal? {
        guard let monthlyBudget = stringToDecimal(SharedUserDefaults.shared.getBudget()) else { return nil }
        let range = Calendar.current.range(of: .day, in: .month, for: date)!
        let numDays = range.count
        
        // Deduct Month Overspending
        let records = Record.getAll()
        let currency = SharedUserDefaults.shared.getCurrency()
        if currency.count <= 0 { return nil }
        let monthSpendingSum = records.filter({
            $0.currency! == currency && (Calendar.current.dateComponents([.year, .month], from: $0.timestamp!) == Calendar.current.dateComponents([.year, .month], from: date))
        }).map({ $0.amount! as Decimal }).reduce(0, +)
        let monthLeft = monthlyBudget - monthSpendingSum
        
        return monthLeft / Decimal(numDays)
    }
    
    static func applyTimezone(_ timestamp: Date) -> Date {
        let timezoneOffset =  TimeZone.current.secondsFromGMT()
        let localizedTimestamp = timestamp.addingTimeInterval(TimeInterval(timezoneOffset))
        return localizedTimestamp
    }
    
    static func groupRecordsByDay() -> [(key: Date, value: [Record])] {
        let format: [Date: [Record]] = [:]
        let records = Record.getAll().reduce(into: format) { store, record in
            let components = Calendar.current.dateComponents([.year, .month, .day], from: record.timestamp!)
            let dailyDate = Calendar.current.date(from: components)!
            let date = applyTimezone(dailyDate)
            let existing = store[date] ?? []
            store[date] = existing + [record]
        }
        return records.sorted(by: {
            return $0.key > $1.key
        })
    }
    
    static func groupRecordsByMonth() -> [(key: Date, value: [Record])] {
        let format: [Date: [Record]] = [:]
        let records = Record.getAll().reduce(into: format) { store, record in
            // Apply timezone for monthly records
            let components = Calendar.current.dateComponents([.year, .month], from: record.timestamp!)
            let monthlyDate = Calendar.current.date(from: components)!
            let date = applyTimezone(monthlyDate)
            let existing = store[date] ?? []
            store[date] = existing + [record]
        }
        return records.sorted(by: {
            return $0.key > $1.key
        })
    }
    
    static func groupRecordsByYear() -> [(key: Date, value: [Record])] {
        let format: [Date: [Record]] = [:]
        let records = Record.getAll().reduce(into: format) { store, record in
            // Apply timezone for monthly records
            let components = Calendar.current.dateComponents([.year], from: record.timestamp!)
            let monthlyDate = Calendar.current.date(from: components)!
            let date = applyTimezone(monthlyDate)
            let existing = store[date] ?? []
            store[date] = existing + [record]
        }
        return records.sorted(by: {
            return $0.key > $1.key
        })
    }
    
    static func todayTotalSpending() -> Decimal? {
        let records = Record.getAll()
        let currency = SharedUserDefaults.shared.getCurrency()
        if currency.count <= 0 { return nil }
        let todaySum = records.filter({
            $0.currency! == currency && (Calendar.current.dateComponents([.year, .month, .day], from: $0.timestamp!) == Calendar.current.dateComponents([.year, .month, .day], from: Date()))
        }).map({ $0.amount! as Decimal }).reduce(0, +)
        return todaySum
    }
    
    static func monthTotalSpending() -> Decimal? {
        let records = Record.getAll()
        let currency = SharedUserDefaults.shared.getCurrency()
        if currency.count <= 0 { return nil }
        let monthSum = records.filter({
            $0.currency! == currency && (Calendar.current.dateComponents([.year, .month], from: $0.timestamp!) == Calendar.current.dateComponents([.year, .month], from: Date()))
        }).map({ $0.amount! as Decimal }).reduce(0, +)
        return monthSum
    }
    
    static func currentTotalSaving() -> Decimal? {
        let wishlist = WishItem.getAll()
        let records = Record.getAll()
        
        let achievedItems = wishlist.filter({ $0.achieved == true }).map({ $0.price! as Decimal }).reduce(0, +)
        
        let currency = SharedUserDefaults.shared.getCurrency()
        if currency.count <= 0 { return nil }
        let recordsSum = records.filter({ $0.currency! == currency }).map({ $0.amount! as Decimal }).reduce(0, +)
        //  && (Calendar.current.dateComponents([.year, .month, .day], from: $0.timestamp!) != Calendar.current.dateComponents([.year, .month, .day], from: Date()))
        
        // Calculate for savings
        guard let startDate = SharedUserDefaults.shared.getStartDate() else { return nil }
        let firstDate = applyTimezone(startDate)
        let currentDate = applyTimezone(Date())
        
        // Replace the hour (time) of both dates with 00:00
        let dateComponent = Calendar.current.dateComponents([.month, .day], from: firstDate, to: currentDate)
        let monthRange = dateComponent.month!
        
        var totalBudget: Decimal = 0
        var totalDays = 0
        
        // First month
        if monthRange == 0 {
            guard let budget = dailyBudget(formonth: startDate) else { return nil }
            let days = dateComponent.day!+1
            totalBudget += budget * Decimal(days)
            totalDays += days
        }
        else {
            // Middle months
            for month in 0..<monthRange {
                let newDate = Calendar.current.date(byAdding: .month, value: month, to: firstDate)!
                let range = Calendar.current.range(of: .day, in: .month, for: newDate)!
                guard let budget = dailyBudget(formonth: newDate) else { return nil }
                let days = range.count
                totalBudget += budget * Decimal(days)
                totalDays += days
            }
            let newDate = Calendar.current.date(byAdding: .month, value: monthRange, to: firstDate)!
            let newComponent = Calendar.current.dateComponents([.year, .month, .day], from: newDate, to: currentDate)
            guard let budget = dailyBudget(formonth: newDate) else { return nil }
            let days = newComponent.day!+1
            totalBudget += budget * Decimal(days)
            totalDays += days
        }
        // today's budget is already included and regarded as current saving
        // print(totalDays)
        var roundedTotal: Decimal = Decimal()
        NSDecimalRound(&roundedTotal, &totalBudget, 2, .plain)
        
        let currentTotalSaving = totalBudget - achievedItems - recordsSum
        return currentTotalSaving
    }
}

