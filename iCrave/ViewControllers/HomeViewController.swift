//
//  HomeViewController.swift
//  iCrave
//
//  Created by Kevin Kim on 16/10/2019.
//  Copyright © 2019 Kevin Kim. All rights reserved.
//

import UIKit
import SafariServices
import Cards
import GradientProgressBar

class HomeViewController: UITableViewController {
    
    var wishItem = WishItem.getSavingItem()
    var records = Record.getRecents()
    
    @IBOutlet var cardView: CardHighlight!
    @IBOutlet var recordsScroll: UIScrollView!
    @IBOutlet var dailyBudgetLabel: UILabel!
    @IBOutlet var dailyBudgetBar: GradientProgressBar!
    @IBOutlet var monthlyBudgetLabel: UILabel!
    @IBOutlet var monthlyBudgetBar: GradientProgressBar!
    @IBOutlet var savingStatusLabel: UILabel!
    @IBOutlet var savingStatusBar: GradientProgressBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if SharedUserDefaults.shared.getBudget().count == 0 || SharedUserDefaults.shared.getCurrency().count == 0 || SharedUserDefaults.shared.getStartDate() == nil {
            let alert = UIAlertController(title: "Settings Needed", message: "Set monthly budget, currency, and start date in Settings.", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .default)
            ok.setValue(UIColor.systemOrange, forKey: "titleTextColor")
            alert.addAction(ok)
            present(alert, animated:true, completion: nil)
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(viewWillAppear(_:)), name: Notification.Name("HomeRefresh"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(viewWillAppear(_:)), name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        updateView()
    }
    
    func updateView() {
        wishItem = WishItem.getSavingItem()
        records = Record.getRecents()
        drawCardView()
        drawRecords()
        drawBars()
    }
    
    func drawCardView() {
        if let item = wishItem {
            cardView.title = item.name!
            cardView.itemTitle = "0 \(item.currency!)"
            cardView.itemSubtitle = "out of \(decimalToString(item.price!)) \(item.currency!)"
            cardView.buttonText = "0%"
            if let totalSaving = DataAnalyzer.currentTotalSaving() {
                cardView.itemTitle = "\(decimalToString(totalSaving)) \(item.currency!)"
                let progress = (totalSaving / (item.price! as Decimal)) * 100 // in percentage
                cardView.buttonText = "\(decimalToString(progress))%"
                
                if progress >= 100 {
                    let budgetAlert = UIAlertController(title: "Congratulations!", message: "You have done saving for\n\(item.name!)!", preferredStyle: .alert)
                    let cancel = UIAlertAction(title: "Cancel", style: .default)
                    let action = UIAlertAction(title: "Achieved", style: .default) { (alertAction) in
                        WishItem.update(wishItem: item, name: item.name!, price: item.price! as Decimal, currency: item.currency!, saving: false, image: item.image, achieved: true)
                        self.updateView()
                    }
                    cancel.setValue(UIColor.systemOrange, forKey: "titleTextColor")
                    action.setValue(UIColor.systemOrange, forKey: "titleTextColor")
                    
                    budgetAlert.addAction(cancel)
                    budgetAlert.addAction(action)
                    present(budgetAlert, animated:true, completion: nil)
                }
            }
            cardView.backgroundColor = .systemBackground
            cardView.textColor = UIColor(named: "DarkText")!
            cardView.backgroundImage = nil
            if let imageData = item.image {
                cardView.backgroundImage = UIImage(data: imageData)
                cardView.textColor = cardView.backgroundImage?.averageColor?.generateStaticTextColor() ?? .black
            }
            cardView.tintColor = .systemOrange
        }
        else {
            cardView.title = "No Wish Item"
            cardView.itemTitle = "Please add"
            cardView.itemSubtitle = "a new wish item"
            cardView.buttonText = "0%"
            cardView.backgroundColor = .systemBackground
            cardView.backgroundImage = nil
            cardView.tintColor = .gray
            cardView.textColor = UIColor(named: "DarkText")!
        }
        // 50 spaces added for flexible constraints - Cards bug
        cardView.title += "                                             "
        cardView.itemTitle += "                                             "
        cardView.itemSubtitle += "                                             "
        cardView.setNeedsDisplay()
        
        let wishlistDetailTap = UITapGestureRecognizer(target: self, action: #selector(wishlistDetailView(sender:)))
        cardView.addGestureRecognizer(wishlistDetailTap)
    }
    
    func drawRecords() {
        for subview in recordsScroll.subviews {
            subview.removeFromSuperview()
        }
        let buttonPadding: CGFloat = 10
        var xOffset: CGFloat = 20
        let height = recordsScroll.frame.height
        let width = height + 10
        
        var card = CardHighlight(frame: CGRect(x: xOffset, y: 0, width: width , height: height))
        
        card.title = "Add\nRecord"
        card.itemTitle = ""
        card.itemSubtitle = ""
        card.buttonText = "➕"
        card.shadowOpacity = 0
        card.backgroundColor = .systemBackground
        card.textColor = UIColor(named: "DarkText")!
        
        let addRecordTap = UITapGestureRecognizer(target: self, action: #selector(showAddRecordView(sender:)))
        card.addGestureRecognizer(addRecordTap)
        
        xOffset = xOffset + CGFloat(buttonPadding) + card.frame.size.width
        recordsScroll.addSubview(card)
        
        for i in 0..<records.count {
            card = CardHighlight(frame: CGRect(x: xOffset, y: 0, width: width , height: height))
            
            card.tag = i
            card.title = records[i].category!.title!
            card.titleSize = 18
            card.itemTitle = ""
            card.itemSubtitle = "\(decimalToString(records[i].amount!)) \(records[i].currency!)"
            card.buttonText = ""
            card.shadowOpacity = 0
            card.backgroundColor = .systemBackground
            card.textColor = UIColor.systemBackground.generateStaticTextColor()
            if let category = records[i].category {
                card.backgroundColor = category.color!.getUIColor()
                card.textColor = category.color!.getUIColor().generateStaticTextColor()
            }
            
            let recentRecordTap = UITapGestureRecognizer(target: self, action: #selector(recentRecordClick(sender:)))
            card.addGestureRecognizer(recentRecordTap)
            
            xOffset = xOffset + CGFloat(buttonPadding) + card.frame.size.width
            recordsScroll.addSubview(card)
        }
        recordsScroll.contentSize = CGSize(width: xOffset+10, height: recordsScroll.frame.height)
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
        
        let currency = SharedUserDefaults.shared.getCurrency()
        if currency.count == 0 { return }
        
        // Daily Budget
        guard let todayBudget = DataAnalyzer.dailyBudget(formonth: Date()) else { return }
        let todaySum = DataAnalyzer.todayTotalSpending() ?? 0
        let dailyLeft = todayBudget - todaySum
        let dailyBudgetProgress = dailyLeft / todayBudget
        
        dailyBudgetLabel.text = "Daily Budget: \(decimalToString(dailyLeft)) / \(decimalToString(todayBudget)) \(currency)"
        if dailyBudgetProgress > 0 {
            dailyBudgetBar.progress = Float(truncating: dailyBudgetProgress as NSNumber)
        }
        
        // Monthly Budget
        let storedBudget = SharedUserDefaults.shared.getBudget()
        if storedBudget.count == 0 { return }
        guard let monthBudget = stringToDecimal(storedBudget) else { return }
        guard let monthSum = DataAnalyzer.monthTotalSpending() else { return }
        let monthLeft = monthBudget - monthSum
        let monthBudgetProgress = monthLeft / monthBudget
        
        monthlyBudgetLabel.text = "Monthly Budget: \(decimalToString(monthLeft)) / \(decimalToString(monthBudget)) \(currency)"
        if monthBudgetProgress > 0 {
            monthlyBudgetBar.progress = Float(truncating: monthBudgetProgress as NSNumber)
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
    
    @objc func showAddRecordView(sender: UIGestureRecognizer) {
        performSegue(withIdentifier: "AddRecordSegue", sender: self)
    }
    
    @objc func wishlistDetailView(sender: UIGestureRecognizer) {
        performSegue(withIdentifier: "Wishlist", sender: sender)
    }
    
    @objc func recentRecordClick(sender: UIGestureRecognizer) {
        let tag = sender.view!.tag
        let record = records[tag]
        
        let alert = UIAlertController(title: "Quick Add", message: "Spent \(decimalToString(record.amount!)) \(record.currency!)\nfor \(record.category!.title!)", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Cancel", style: .default)
        let action = UIAlertAction(title: "Add", style: .default) { (alertAction) in
            Record.create(in: record.category!, timestamp: Date(), amount: record.amount! as Decimal, currency: record.currency!)
            self.updateView()
        }
        cancel.setValue(UIColor.systemOrange, forKey: "titleTextColor")
        action.setValue(UIColor.systemOrange, forKey: "titleTextColor")
        alert.addAction(cancel)
        alert.addAction(action)
        present(alert, animated:true, completion: nil)
    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat.leastNonzeroMagnitude
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNonzeroMagnitude
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }

}
