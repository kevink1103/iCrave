//
//  StatisticsTableViewController.swift
//  iCrave
//
//  Created by Kevin Kim on 25/11/2019.
//  Copyright © 2019 Kevin Kim. All rights reserved.
//

import UIKit
import Charts

class StatisticsTableViewController: UITableViewController {

    @IBOutlet var periodControl: UISegmentedControl!
    @IBOutlet var spendingChart: BarChartView!
    @IBOutlet var savingChart: BarChartView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        spendingChart.isUserInteractionEnabled = false
        spendingChart.legend.enabled = false
        spendingChart.xAxis.avoidFirstLastClippingEnabled = true
        spendingChart.xAxis.drawGridLinesEnabled = false
        spendingChart.leftAxis.enabled = false
        spendingChart.rightAxis.enabled = false
        spendingChart.xAxis.labelPosition = .bottom
        spendingChart.backgroundColor = .systemBackground
        
        
        savingChart.isUserInteractionEnabled = false
        savingChart.legend.enabled = false
        savingChart.xAxis.avoidFirstLastClippingEnabled = true
        savingChart.xAxis.drawGridLinesEnabled = false
        savingChart.leftAxis.enabled = false
        savingChart.rightAxis.enabled = false
        savingChart.xAxis.labelPosition = .bottom
        savingChart.backgroundColor = .systemBackground

        drawCharts()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        drawCharts()
    }
    
    func drawCharts() {
        var spendingEntries: [BarChartDataEntry] = []
        var savingEntries: [BarChartDataEntry] = []
        let now = Date()
        guard let startDate = SharedUserDefaults.shared.getStartDate() else { return }
        let mode = periodControl.selectedSegmentIndex
        switch (mode) {
        case 0:
            let data = DataAnalyzer.groupRecordsByDay()
            for day in 1...7 {
                let newDate = Calendar.current.date(byAdding: .day, value: -7+day, to: now)!
                let newComponent = Calendar.current.dateComponents([.year, .month, .day], from: newDate)
                let x = newComponent.day!
                var y: Double = 0
                let filterData = data.filter({
                    Calendar.current.dateComponents([.year, .month, .day], from: $0.key) == newComponent
                }).map({ $0.value.map({ $0.amount! as Decimal }).reduce(0, +) })
                if filterData.count > 0 {
                    y = Double(truncating: filterData[0] as NSNumber)
                }
                spendingEntries.append(BarChartDataEntry(x: Double(x), y: y))
                
                let today = Calendar.current.dateComponents([.year, .month, .day], from: Date())
                let monthDays = Calendar.current.range(of: .day, in: .month, for: Date())!.count
                guard let totalSaving = DataAnalyzer.currentTotalSaving() else { return }
                guard let todayBudget = DataAnalyzer.dailyBudget(formonth: newDate) else { return }
                var todaySum: Decimal = 0
                if filterData.count > 0 {
                    todaySum = filterData[0]
                }
                
                var todayLeft: Decimal = 0
                if totalSaving >= 0 {
                    todayLeft = todayBudget - todaySum
                }
                else {
                    let newTodayBudget = todayBudget + (totalSaving / Decimal(monthDays - today.day!))
                    todayLeft = newTodayBudget - todaySum
                }
                
                if startDate < DataAnalyzer.applyTimezone(newDate) {
                    savingEntries.append(BarChartDataEntry(x: Double(x), y: Double(truncating: todayLeft as NSNumber)))
                }
                else {
                    savingEntries.append(BarChartDataEntry(x: Double(x), y: 0))
                }
            }
        case 1:
            let data = DataAnalyzer.groupRecordsByDay()
            let range = Calendar.current.range(of: .day, in: .month, for: Date())!.count
            for day in 1...range {
                var newComponent = Calendar.current.dateComponents([.year, .month, .day], from: now)
                newComponent.day = day
                let x = newComponent.day!
                var y: Double = 0
                let filterData = data.filter({
                    Calendar.current.dateComponents([.year, .month, .day], from: $0.key) == newComponent
                }).map({ $0.value.map({ $0.amount! as Decimal }).reduce(0, +) })
                if filterData.count > 0 {
                    y = Double(truncating: filterData[0] as NSNumber)
                }
                spendingEntries.append(BarChartDataEntry(x: Double(x), y: y))
                
                let today = Calendar.current.dateComponents([.year, .month, .day], from: Date())
                let monthDays = Calendar.current.range(of: .day, in: .month, for: Date())!.count
                guard let totalSaving = DataAnalyzer.currentTotalSaving() else { return }
                newComponent.day! += 1
                guard let newDate = Calendar.current.date(from: newComponent) else { return }
                guard let todayBudget = DataAnalyzer.dailyBudget(formonth: newDate) else { return }
                var todaySum: Decimal = 0
                if filterData.count > 0 {
                    todaySum = filterData[0]
                }
                
                var todayLeft: Decimal = 0
                if totalSaving >= 0 {
                    todayLeft = todayBudget - todaySum
                }
                else {
                    let newTodayBudget = todayBudget + (totalSaving / Decimal(monthDays - today.day!))
                    todayLeft = newTodayBudget - todaySum
                }
                
                if startDate < DataAnalyzer.applyTimezone(newDate) && newDate < DataAnalyzer.applyTimezone(now) {
                    savingEntries.append(BarChartDataEntry(x: Double(x), y: Double(truncating: todayLeft as NSNumber)))
                }
                else {
                    savingEntries.append(BarChartDataEntry(x: Double(x), y: 0))
                }
            }
        case 2:
            let data = DataAnalyzer.groupRecordsByMonth()
            for month in 1...12 {
                let newDate = Calendar.current.date(byAdding: .month, value: -12+month, to: now)!
                let newComponent = Calendar.current.dateComponents([.year, .month], from: newDate)
                let x = newComponent.month!
                var y: Double = 0
                let filterData = data.filter({
                    Calendar.current.dateComponents([.year, .month], from: $0.key) == newComponent
                }).map({ $0.value.map({ $0.amount! as Decimal }).reduce(0, +) })
                if filterData.count > 0 {
                    y = Double(truncating: filterData[0] as NSNumber)
                }
                spendingEntries.append(BarChartDataEntry(x: Double(x), y: y))
                
                let storedBudget = SharedUserDefaults.shared.getBudget()
                if storedBudget.count == 0 { return }
                guard let monthBudget = stringToDecimal(storedBudget) else { return }
                var monthSum: Decimal = 0
                if filterData.count > 0 {
                    monthSum = filterData[0]
                }
                
                guard let startDate = SharedUserDefaults.shared.getStartDate() else { return }
                let firstDate = DataAnalyzer.applyTimezone(startDate)
                let currentDate = DataAnalyzer.applyTimezone(Date())
                let dateComponent = Calendar.current.dateComponents([.month, .day], from: firstDate, to: currentDate)
                let monthRange = dateComponent.month!
                guard let todayBudget = DataAnalyzer.dailyBudget(formonth: currentDate) else { return }
                
                var monthLeft: Decimal = 0
                if monthRange == 0 {
                    let passedDay = Calendar.current.dateComponents([.day], from: firstDate).day! - 1
                    let newMonthBudget = monthBudget - (todayBudget * Decimal(passedDay))
                    monthLeft = newMonthBudget - monthSum
                }
                else {
                    monthLeft = monthBudget - monthSum
                }
                
                if startDate < DataAnalyzer.applyTimezone(newDate) && newDate < DataAnalyzer.applyTimezone(now) {
                    savingEntries.append(BarChartDataEntry(x: Double(x), y: Double(truncating: monthLeft as NSNumber)))
                }
                else {
                    savingEntries.append(BarChartDataEntry(x: Double(x), y: 0))
                }
            }
        default:
            return
        }
        let spendingDataSet = BarChartDataSet(entries: spendingEntries)
        let spendingChartData = BarChartData(dataSet: spendingDataSet)
        spendingDataSet.colors = [UIColor(red: 230/255, green: 126/255, blue: 34/255, alpha: 1)]
        spendingChartData.barWidth = 0.5
        spendingChart.data = spendingChartData
        spendingChart.xAxis.labelCount = spendingEntries.count
        if spendingEntries.count >= 30 {
            spendingChart.xAxis.labelCount = spendingEntries.count / 2
        }
        spendingChart.animate(xAxisDuration: 0.5, yAxisDuration: 1.5)
        
        let savingDataSet = BarChartDataSet(entries: savingEntries)
        let savingChartData = BarChartData(dataSet: savingDataSet)
        savingDataSet.colors = [UIColor(red: 230/255, green: 126/255, blue: 34/255, alpha: 1)]
        savingChartData.barWidth = 0.5
        savingChart.data = savingChartData
        savingChart.xAxis.labelCount = savingEntries.count
        if savingEntries.count >= 30 {
            savingChart.xAxis.labelCount = savingEntries.count / 2
        }
        savingChart.animate(xAxisDuration: 0.5, yAxisDuration: 1.5)
    }
    
    @IBAction func periodChanged(_ sender: Any) {
        drawCharts()
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
