//
//  TodayViewController.swift
//  Widget
//
//  Created by Kevin Kim on 27/11/2019.
//  Copyright © 2019 Kevin Kim. All rights reserved.
//

import UIKit
import NotificationCenter
import GradientProgressBar

class TodayViewController: UIViewController, NCWidgetProviding {
        
    @IBOutlet var dailyBudgetLabel: UILabel!
    @IBOutlet var dailyBudgetBar: GradientProgressBar!
    @IBOutlet var monthlyBudgetLabel: UILabel!
    @IBOutlet var monthlyBudgetBar: GradientProgressBar!
    @IBOutlet var savingStatusLabel: UILabel!
    @IBOutlet var savingStatusBar: GradientProgressBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        extensionContext?.widgetLargestAvailableDisplayMode = .expanded
    }
    
    override func viewWillAppear(_ animated: Bool) {
        drawBars()
    }
        
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.
        
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        drawBars()
        completionHandler(NCUpdateResult.newData)
    }
    
    func widgetActiveDisplayModeDidChange(_ activeDisplayMode: NCWidgetDisplayMode, withMaximumSize maxSize: CGSize) {
        if activeDisplayMode == NCWidgetDisplayMode.compact {
            //compact
            self.preferredContentSize = maxSize
        } else {
            //extended
            self.preferredContentSize = CGSize(width: maxSize.width, height: 180)
        }
    }
    
    func drawBars() {
        // Default Appearance
        dailyBudgetBar.gradientColors = [.systemOrange, .systemOrange, .systemOrange]
        monthlyBudgetBar.gradientColors = [.systemOrange, .systemOrange, .systemOrange]
        savingStatusBar.gradientColors = [.systemOrange, .systemOrange, .systemOrange]
        dailyBudgetBar.gradientLayer.cornerRadius = 10
        dailyBudgetBar.layer.cornerRadius = 10
        monthlyBudgetBar.gradientLayer.cornerRadius = 10
        monthlyBudgetBar.layer.cornerRadius = 10
        savingStatusBar.gradientLayer.cornerRadius = 10
        savingStatusBar.layer.cornerRadius = 10
        dailyBudgetBar.progress = 0.0
        monthlyBudgetBar.progress = 0.0
        savingStatusBar.progress = 0.0
        dailyBudgetLabel.text = "Daily Budget"
        monthlyBudgetLabel.text = "Monthly Budget"
        savingStatusLabel.text = "Saving Status"
        
        let wishItem = WishItem.getSavingItem()
    
        let currency = SharedUserDefaults.shared.getCurrency()
        if currency.count == 0 { return }
        let storedBudget = SharedUserDefaults.shared.getBudget()
        if storedBudget.count == 0 { return }
        guard let monthBudget = stringToDecimal(storedBudget) else { return }
    
        let today = Calendar.current.dateComponents([.year, .month, .day], from: Date())
        let monthDays = Calendar.current.range(of: .day, in: .month, for: Date())!.count
        guard let totalSaving = DataAnalyzer.currentTotalSaving() else { return }
        guard let todayBudget = DataAnalyzer.dailyBudget(formonth: Date()) else { return }
        let todaySum = DataAnalyzer.todayTotalSpending() ?? 0
        let monthSum = DataAnalyzer.monthTotalSpending() ?? 0
    
        if totalSaving >= 0 {
            let todayLeft = todayBudget - todaySum
            let dailyBudgetProgress = todayLeft / todayBudget
            dailyBudgetLabel.text = "Daily Budget: \(decimalToString(todayLeft)) / \(decimalToString(todayBudget)) \(currency)"
            if dailyBudgetProgress > 0 {
                dailyBudgetBar.progress = Float(truncating: dailyBudgetProgress as NSNumber)
            }
        }
        else {
            let newTodayBudget = todayBudget + (totalSaving / Decimal(monthDays - today.day!))
            let todayLeft = newTodayBudget - todaySum
            let dailyBudgetProgress = todayLeft / newTodayBudget
            dailyBudgetLabel.text = "Daily Budget: \(decimalToString(todayLeft)) / \(decimalToString(newTodayBudget)) \(currency)"
            if dailyBudgetProgress > 0 {
                dailyBudgetBar.progress = Float(truncating: dailyBudgetProgress as NSNumber)
            }
        }
    
        guard let firstDate = SharedUserDefaults.shared.getStartDate() else { return }
        let currentDate = DataAnalyzer.applyTimezone(Date())
        let dateComponent = Calendar.current.dateComponents([.month, .day], from: firstDate, to: currentDate)
        let monthRange = dateComponent.month!
    
        if monthRange == 0 {
            let passedDay = Calendar.current.dateComponents([.year, .month, .day], from: firstDate).day! - 1
            let newMonthBudget = monthBudget - (todayBudget * Decimal(passedDay))
            let monthLeft = newMonthBudget - monthSum
            let monthBudgetProgress = monthLeft / monthBudget
            monthlyBudgetLabel.text = "Monthly Budget: \(decimalToString(monthLeft)) / \(decimalToString(monthBudget)) \(currency)"
            if monthBudgetProgress > 0 {
                monthlyBudgetBar.progress = Float(truncating: monthBudgetProgress as NSNumber)
            }
        }
        else {
            let monthLeft = monthBudget - monthSum
            let monthBudgetProgress = monthLeft / monthBudget
            monthlyBudgetLabel.text = "Monthly Budget: \(decimalToString(monthLeft)) / \(decimalToString(monthBudget)) \(currency)"
            if monthBudgetProgress > 0 {
                monthlyBudgetBar.progress = Float(truncating: monthBudgetProgress as NSNumber)
            }
        }
    
        // Saving Status
        if let item = wishItem {
            if let totalSaving = DataAnalyzer.currentTotalSaving() {
                let savingProgress = totalSaving / (item.price! as Decimal)
                savingStatusLabel.text = "Saving Status: \(decimalToString(totalSaving)) / \(decimalToString((item.price! as Decimal))) \(currency)"
                if savingProgress > 0 {
                    savingStatusBar.progress = Float(truncating: savingProgress as NSNumber)
                }
            }
        }
    
    }
    
}
