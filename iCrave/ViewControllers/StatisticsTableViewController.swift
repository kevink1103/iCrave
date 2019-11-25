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
        spendingChart.xAxis.avoidFirstLastClippingEnabled = false
        spendingChart.xAxis.drawGridLinesEnabled = false
        spendingChart.leftAxis.enabled = false
        spendingChart.rightAxis.enabled = false
        spendingChart.xAxis.labelPosition = .bottom
        spendingChart.backgroundColor = .systemBackground
        
        
        savingChart.isUserInteractionEnabled = false
        savingChart.legend.enabled = false
        savingChart.xAxis.avoidFirstLastClippingEnabled = false
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
        drawSpendingChart()
        drawSavingChart()
    }
    
    func drawSpendingChart() {
        var dataEntries: [BarChartDataEntry] = []
        let now = Date()
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
                dataEntries.append(BarChartDataEntry(x: Double(x), y: y))
            }
        case 1:
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
                dataEntries.append(BarChartDataEntry(x: Double(x), y: y))
            }
        case 2:
            let data = DataAnalyzer.groupRecordsByYear()
            for year in 1...10 {
                let newDate = Calendar.current.date(byAdding: .year, value: -10+year, to: now)!
                let newComponent = Calendar.current.dateComponents([.year], from: newDate)
                let x = newComponent.year!
                var y: Double = 0
                let filterData = data.filter({
                    Calendar.current.dateComponents([.year], from: $0.key) == newComponent
                }).map({ $0.value.map({ $0.amount! as Decimal }).reduce(0, +) })
                if filterData.count > 0 {
                    y = Double(truncating: filterData[0] as NSNumber)
                }
                dataEntries.append(BarChartDataEntry(x: Double(x), y: y))
            }
        default:
            return
        }
        let chartDataSet = BarChartDataSet(entries: dataEntries)
        let chartData = BarChartData(dataSet: chartDataSet)
        chartDataSet.colors = [UIColor(red: 230/255, green: 126/255, blue: 34/255, alpha: 1)]
        chartData.barWidth = 0.5
        spendingChart.data = chartData
        spendingChart.xAxis.labelCount = dataEntries.count
        spendingChart.animate(xAxisDuration: 0.5, yAxisDuration: 1.5)
    }
    
    func drawSavingChart() {
        var dataEntries: [BarChartDataEntry] = []
        let now = DataAnalyzer.applyTimezone(Date())
        let mode = periodControl.selectedSegmentIndex
        switch (mode) {
        case 0:
            print("daily")
        case 1:
            print("monthly")
        case 2:
            print("yearly")
        default:
            return
        }
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
