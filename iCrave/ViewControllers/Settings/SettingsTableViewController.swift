//
//  SettingsTableViewController.swift
//  iCrave
//
//  Created by Kevin Kim on 22/10/2019.
//  Copyright © 2019 Kevin Kim. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController {
    
    var categories: [Category] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 60
        tableView.delaysContentTouches = false
        NotificationCenter.default.addObserver(self, selector: #selector(viewWillAppear(_:)), name: Notification.Name("CategoryRefresh"), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        categories = Category.getAll()
        tableView.reloadData()
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch (section) {
        case 0:
            return categories.count + 1
        case 1:
            return 2
        case 2:
            return 3
        default:
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch (section) {
        case 0:
            return "Categories"
        case 1:
            return "Monetary"
        case 2:
            return "Notifications"
        default:
            return ""
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        switch (section) {
        case 0:
            return "Add a new category to keep your spending."
        case 1:
            return "Set up your monthly budget and currency."
        case 2:
            return "Adjust your notification preferences."
        default:
            return ""
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        // Configure the cell...
        let section = indexPath.section
        let row = indexPath.row
        
        if section == 0 {
            if row < categories.count {
                let category = categories[row]
                cell.textLabel?.text = category.title!
                cell.textLabel?.textColor = category.color!.getUIColor().generateStaticTextColor()
                cell.backgroundColor = category.color!.getUIColor()
            } else {
                cell.textLabel?.text = "Add Category"
                cell.textLabel?.textColor = .systemRed
                cell.backgroundColor = .secondarySystemBackground
            }
            // Optimization for select style default
            let selectedBgView = UIView()
            selectedBgView.backgroundColor = cell.backgroundColor
            cell.selectedBackgroundView = selectedBgView
        }
        else if section == 1 {
            cell = tableView.dequeueReusableCell(withIdentifier: "MoneyCell", for: indexPath)
            switch (row) {
            case 0:
                cell.textLabel?.text = "Monthly Budget"
                cell.detailTextLabel?.text = "5000"
            case 1:
                cell.textLabel?.text = "Currency"
                cell.detailTextLabel?.text = "HKD"
            default:
                cell.textLabel?.text = ""
            }
        }
        else if section == 2 {
            cell = tableView.dequeueReusableCell(withIdentifier: "NotiCell", for: indexPath)
            let switchView = UISwitch(frame: .zero)
            switchView.setOn(false, animated: true)
            switchView.tag = indexPath.row
            switchView.addTarget(self, action: #selector(switchChanged(_:)), for: .valueChanged)
            cell.accessoryView = switchView
            
            switch (row) {
            case 0:
                cell.textLabel?.text = "Morning Reminder"
            case 1:
                cell.textLabel?.text = "Evening Reminder"
            case 2:
                cell.textLabel?.text = "Monthly Report"
            default:
                cell.textLabel?.text = ""
            }
        }
        
        return cell
    }
    
    @objc func switchChanged(_ sender : UISwitch!){
          print("table row switch Changed \(sender.tag)")
          print("The switch is \(sender.isOn ? "ON" : "OFF")")
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            if indexPath.row < categories.count {
                performSegue(withIdentifier: "EditCategory", sender: categories[indexPath.row])
            }
            else {
                performSegue(withIdentifier: "AddCategory", sender: self)
            }
        }
        
    }

    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        if indexPath.section == 0 && indexPath.row < categories.count {
            return true
        }
        return false
    }

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            Category.delete(category: categories[indexPath.row])
            categories.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "EditCategory" {
            if let destinationVC = segue.destination as? EditCategoryViewController {
                destinationVC.category = sender as? Category
            }
        }
    }

}
