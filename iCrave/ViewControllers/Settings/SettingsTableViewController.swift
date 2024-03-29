//
//  SettingsTableViewController.swift
//  iCrave
//
//  Created by Kevin Kim on 22/10/2019.
//  Copyright © 2019 Kevin Kim. All rights reserved.
//

import UIKit
import ActionSheetPicker_3_0

class SettingsTableViewController: UITableViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
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
        return 4
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch (section) {
        case 0:
            return categories.count + 1
        case 1:
            return 3
        case 2:
            return 3
        case 3:
            return 5
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
        case 3:
            return "Danger Zone"
        default:
            return ""
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        switch (section) {
        case 0:
            return "Add a new category to keep your spending."
        case 1:
            return "Set up your monthly budget, currency, and start saving date."
        case 2:
            return "Adjust your notification preferences."
        case 3:
            return "Reset data you want."
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
        }
        else if section == 1 {
            cell = tableView.dequeueReusableCell(withIdentifier: "MoneyCell", for: indexPath)
            
            switch (row) {
            case 0:
                cell.textLabel?.text = "Monthly Budget"
                cell.detailTextLabel?.text = "Tap to set"
                if let decimalBudget = stringToDecimal(SharedUserDefaults.shared.getBudget()) {
                    cell.detailTextLabel?.text = decimalToString(decimalBudget)
                }
            case 1:
                cell.textLabel?.text = "Currency"
                cell.detailTextLabel?.text = "Tap to set"
                let currency = SharedUserDefaults.shared.getCurrency()
                if currency.count > 0 {
                    cell.detailTextLabel?.text = currency
                }
            case 2:
                cell.textLabel?.text = "Start Date"
                cell.detailTextLabel?.text = "Tap to set"
                if let date = SharedUserDefaults.shared.getStartDate() {
                    let formatter: DateFormatter = DateFormatter()
                    formatter.dateFormat = "dd MMM yyyy"
                    let dateString = formatter.string(from: date)
                    cell.detailTextLabel?.text = dateString
                }
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
            var status = false
            
            switch (row) {
            case 0:
                cell.textLabel?.text = "Morning Reminder"
                status = SharedUserDefaults.shared.getNotification(id: "morning")
            case 1:
                cell.textLabel?.text = "Evening Reminder"
                status = SharedUserDefaults.shared.getNotification(id: "evening")
            case 2:
                cell.textLabel?.text = "Monthly Report"
                status = SharedUserDefaults.shared.getNotification(id: "monthly")
            default:
                cell.textLabel?.text = ""
            }
            switchView.setOn(status, animated: true)
        }
        else if section == 3 {
            cell = tableView.dequeueReusableCell(withIdentifier: "ResetCell", for: indexPath)
            
            switch (row) {
            case 0:
                cell.textLabel?.text = "Reset Categories"
            case 1:
                cell.textLabel?.text = "Reset Records"
            case 2:
                cell.textLabel?.text = "Reset Wishlist"
            case 3:
                cell.textLabel?.text = "Reset Monetary"
            case 4:
                cell.textLabel?.text = "Reset All"
            default:
                cell.textLabel?.text = ""
            }
        }
        // Optimization for select style default
        let selectedBgView = UIView()
        selectedBgView.backgroundColor = cell.backgroundColor
        cell.selectedBackgroundView = selectedBgView
        
        return cell
    }
    
    @objc func switchChanged(_ sender : UISwitch!) {
        //notification
        let manager = LocalNotificationManager()
        guard let dailyBudget = DataAnalyzer.dailyBudget(formonth: DataAnalyzer.applyTimezone(Date())) else { return }
        let amount = decimalToString(dailyBudget)
        var date = DateComponents()
        date.timeZone = TimeZone.current
        date.hour = 8
        date.minute = 0
        let morning = myNotification(id: "morning", title: "Your Daily Budget", body: "For today, you can use $\(amount). Spend less to afford your goal.", datetime: date)
        date.hour = 21
        let evening = myNotification(id: "evening", title: "How much did you spend today?", body: "Don't forget to record your spendings for today.", datetime: date)
        date.hour = 8
        date.day = 28
        let monthly = myNotification(id: "monthly", title: "Your wishitem is on your way!", body: "Check out the latest saving progress to buy your wishitem.", datetime: date)
        
        switch (sender.tag) {
        case 0:
            if (sender.isOn) {
                SharedUserDefaults.shared.setNotification(id: morning.id, mode: true)
                manager.notifications.append(morning)
            } else {
                SharedUserDefaults.shared.setNotification(id: morning.id, mode: false)
                manager.cancelNoti(id: "morning")
            }
        case 1:
            if (sender.isOn) {
                SharedUserDefaults.shared.setNotification(id: evening.id, mode: true)
                manager.notifications.append(evening)
            } else {
                SharedUserDefaults.shared.setNotification(id: evening.id, mode: false)
                manager.cancelNoti(id: "evening")
            }
        case 2:
            if (sender.isOn) {
                SharedUserDefaults.shared.setNotification(id: monthly.id, mode: true)
                manager.notifications.append(monthly)
            } else {
                SharedUserDefaults.shared.setNotification(id: monthly.id, mode: true)
                manager.cancelNoti(id: "monthly")
            }
        default:
            break
        }
        manager.schedule()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let section = indexPath.section
        let row = indexPath.row
        
        if section == 0 {
            if row < categories.count {
                performSegue(withIdentifier: "EditCategory", sender: categories[indexPath.row])
            }
            else {
                performSegue(withIdentifier: "AddCategory", sender: self)
            }
        }
        else if section == 1 {
            switch (row) {
            case 0:
                // Set Budget
                let budgetAlert = UIAlertController(title: "Monthly Budget", message: "Set your monthly budget.", preferredStyle: .alert)
                budgetAlert.addTextField { (textField) in
                    textField.placeholder = "Amount"
                    textField.keyboardType = .decimalPad
                }
                let cancel = UIAlertAction(title: "Cancel", style: .default)
                let action = UIAlertAction(title: "Set", style: .default) { (alertAction) in
                    let textField = budgetAlert.textFields![0] as UITextField
                    if stringToDecimal(textField.text!) != nil {
                        SharedUserDefaults.shared.setBudget(budget: textField.text!)
                        self.tableView.reloadData()
                    }
                }
                cancel.setValue(UIColor.systemOrange, forKey: "titleTextColor")
                action.setValue(UIColor.systemOrange, forKey: "titleTextColor")
                
                budgetAlert.addAction(cancel)
                budgetAlert.addAction(action)
                present(budgetAlert, animated:true, completion: nil)
            case 1:
                // Set Currency
                let initCurrency = SharedUserDefaults.shared.getCurrency()
                let initIndex = NSLocale.isoCurrencyCodes.firstIndex(of: initCurrency) ?? 0
                
                let currencyPicker = ActionSheetStringPicker(title: "Currency", rows: NSLocale.isoCurrencyCodes, initialSelection: initIndex, doneBlock: { picker, index, value in
                    let currency = value as! String
                    SharedUserDefaults.shared.setCurrency(currency: currency)
                    self.tableView.reloadData()
                }, cancel: { ActionStringCancelBlock in return }, origin: self.view)
                
                let paragraphStyle = NSMutableParagraphStyle()
                paragraphStyle.alignment = .center
                currencyPicker?.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(named: "DarkText")!, NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 20), NSAttributedString.Key.paragraphStyle: paragraphStyle]
                currencyPicker?.pickerTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(named: "DarkText")!, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 25), NSAttributedString.Key.paragraphStyle: paragraphStyle]
                currencyPicker?.pickerBackgroundColor = .systemBackground
                currencyPicker?.toolbarBackgroundColor = .systemBackground
                currencyPicker?.toolbarButtonsColor = .systemOrange
                
                currencyPicker?.show()
            case 2:
                let initDate = SharedUserDefaults.shared.getStartDate() ?? Date()
                let datePicker = ActionSheetDatePicker(title: "Start Date", datePickerMode: .date, selectedDate: initDate, doneBlock: { picker, date, value in
                    SharedUserDefaults.shared.setStartDate(date: date as! Date)
                    self.tableView.reloadData()
                }, cancel: { ActionDateCancelBlock in return }, origin: self.view)
                
                let paragraphStyle = NSMutableParagraphStyle()
                paragraphStyle.alignment = .center
                datePicker?.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(named: "DarkText")!, NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 20), NSAttributedString.Key.paragraphStyle: paragraphStyle]
                datePicker?.pickerTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(named: "DarkText")!, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 25), NSAttributedString.Key.paragraphStyle: paragraphStyle]
                datePicker?.pickerBackgroundColor = .systemBackground
                datePicker?.toolbarBackgroundColor = .systemBackground
                datePicker?.toolbarButtonsColor = .systemOrange
                
                datePicker?.show()
            default:
                return
            }
        }
        else if section == 3 {
            switch (row) {
            case 0:
                let budgetAlert = UIAlertController(title: "Reset Categories", message: nil, preferredStyle: .alert)
                let cancel = UIAlertAction(title: "Cancel", style: .default)
                let action = UIAlertAction(title: "Reset", style: .destructive) { (alertAction) in
                    Category.deleteAll()
                    self.tableView.reloadData()
                }
                cancel.setValue(UIColor.systemOrange, forKey: "titleTextColor")
                
                budgetAlert.addAction(cancel)
                budgetAlert.addAction(action)
                present(budgetAlert, animated:true, completion: nil)
            case 1:
                let budgetAlert = UIAlertController(title: "Reset Records", message: nil, preferredStyle: .alert)
                let cancel = UIAlertAction(title: "Cancel", style: .default)
                let action = UIAlertAction(title: "Reset", style: .destructive) { (alertAction) in
                    Record.deleteAll()
                }
                cancel.setValue(UIColor.systemOrange, forKey: "titleTextColor")
                
                budgetAlert.addAction(cancel)
                budgetAlert.addAction(action)
                present(budgetAlert, animated:true, completion: nil)
            case 2:
                let budgetAlert = UIAlertController(title: "Reset Wishlist", message: nil, preferredStyle: .alert)
                let cancel = UIAlertAction(title: "Cancel", style: .default)
                let action = UIAlertAction(title: "Reset", style: .destructive) { (alertAction) in
                    WishItem.deleteAll()
                }
                cancel.setValue(UIColor.systemOrange, forKey: "titleTextColor")
                
                budgetAlert.addAction(cancel)
                budgetAlert.addAction(action)
                present(budgetAlert, animated:true, completion: nil)
            case 3:
                let budgetAlert = UIAlertController(title: "Reset Monetary", message: nil, preferredStyle: .alert)
                let cancel = UIAlertAction(title: "Cancel", style: .default)
                let action = UIAlertAction(title: "Reset", style: .destructive) { (alertAction) in
                    SharedUserDefaults.shared.resetAll()
                    self.tableView.reloadData()
                }
                cancel.setValue(UIColor.systemOrange, forKey: "titleTextColor")
                
                budgetAlert.addAction(cancel)
                budgetAlert.addAction(action)
                present(budgetAlert, animated:true, completion: nil)
            case 4:
                let budgetAlert = UIAlertController(title: "Reset All", message: nil, preferredStyle: .alert)
                let cancel = UIAlertAction(title: "Cancel", style: .default)
                let action = UIAlertAction(title: "Reset", style: .destructive) { (alertAction) in
                    Category.deleteAll()
                    Record.deleteAll()
                    WishItem.deleteAll()
                    SharedUserDefaults.shared.resetAll()
                    self.tableView.reloadData()
                }
                cancel.setValue(UIColor.systemOrange, forKey: "titleTextColor")
                
                budgetAlert.addAction(cancel)
                budgetAlert.addAction(action)
                present(budgetAlert, animated:true, completion: nil)
            default:
                return
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
            let category = self.categories[indexPath.row]
            let innerRecords = Record.getAll(in: category)
            
            if innerRecords.count > 0 {
                let budgetAlert = UIAlertController(title: "Delete Category", message: "Records belong to this category will be moved to Others.", preferredStyle: .alert)
                let cancel = UIAlertAction(title: "Cancel", style: .default)
                let action = UIAlertAction(title: "Confirm", style: .destructive) { (alertAction) in
                    if Category.getObject(title: "Others") == nil {
                        Category.create(title: "Others", color: "white")
                    }
                    let newCategory = Category.getObject(title: "Others")!
                    for record in innerRecords {
                        category.removeFromRecord(record)
                        newCategory.addToRecord(record)
                    }
                    Category.delete(category: category)
                    self.categories.remove(at: indexPath.row)
                    self.tableView.deleteRows(at: [indexPath], with: .fade)
                    self.tableView.reloadData()
                }
                cancel.setValue(UIColor.systemOrange, forKey: "titleTextColor")
                
                budgetAlert.addAction(cancel)
                budgetAlert.addAction(action)
                present(budgetAlert, animated:true, completion: nil)
            }
            else {
                Category.delete(category: category)
                categories.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
                tableView.reloadData()
            }
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return NSLocale.isoCurrencyCodes.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return NSLocale.isoCurrencyCodes[row]
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
