//
//  RecordListTableViewController.swift
//  iCrave
//
//  Created by Kevin Kim on 17/10/2019.
//  Copyright © 2019 Kevin Kim. All rights reserved.
//

import UIKit

class RecordListTableViewController: UITableViewController {
    
    var dailyRecords: [(key: Date, value: [Record])] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 60
    }
    
    override func viewWillAppear(_ animated: Bool) {
        dailyRecords = groupRecordsByday()
    }
    
    func groupRecordsByday() -> [(key: Date, value: [Record])] {
        let format: [Date: [Record]] = [:]
        let records = Record.getAll().reduce(into: format) { store, record in
            let components = Calendar.current.dateComponents([.year, .month, .day], from: record.timestamp!)
            let date = Calendar.current.date(from: components)!
            let existing = store[date] ?? []
            store[date] = existing + [record]
        }
        return records.sorted(by: {
            return $0.key > $1.key
        })
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        // return dailyRecords.keys.count
        return dailyRecords.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return dailyRecords[section].value.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecordCell", for: indexPath)

        // Configure the cell...
        let record = dailyRecords[indexPath.section].value[indexPath.row]
        cell.textLabel?.text = record.category!.title!
        cell.detailTextLabel?.text = "\(decimalToString(record.amount!)) \(record.currency!)"
        cell.backgroundColor = record.category!.color!.getUIColor()
        cell.textLabel?.textColor = record.category!.color!.getUIColor().generateStaticTextColor()
        cell.detailTextLabel?.textColor = record.category!.color!.getUIColor().generateStaticTextColor()
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let formatter: DateFormatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd (eee)"
        let dayString = formatter.string(from: dailyRecords[section].key)
        return dayString
    }

    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

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
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title:  "Delete", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            let record = self.dailyRecords[indexPath.section].value[indexPath.row]
            let category = record.category!
            
            Record.delete(in: category, record: record)
            self.dailyRecords[indexPath.section].value.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            if self.dailyRecords[indexPath.section].value.count == 0 {
                self.dailyRecords.remove(at: indexPath.section)
                tableView.deleteSections([indexPath.section], with: .fade)
            }
            success(true)
        })
        let editAction = UIContextualAction(style: .normal, title:  "Edit", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            // let item = self.records[indexPath.row]
            // self.performSegue(withIdentifier: "EditWishItem", sender: item)
            // success(true)
        })
        return UISwipeActionsConfiguration(actions: [deleteAction, editAction])
    }

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
