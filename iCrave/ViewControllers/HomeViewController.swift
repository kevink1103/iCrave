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

class HomeViewController: UITableViewController {
    
    var wishItem = WishItem.getSavingItem()
    var records = Record.getRecents()
    
    @IBOutlet var cardView: CardHighlight!
    @IBOutlet var recordsScroll: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
    }
    
    func drawCardView() {
        if let item = wishItem {
            cardView.title = item.name!
            cardView.itemTitle = "0 \(item.currency!)"
            cardView.itemSubtitle = "out of \(decimalToString(item.price!)) \(item.currency!)"
            cardView.buttonText = "0%"
            cardView.backgroundColor = .white
            cardView.backgroundImage = nil
            if let imageData = item.image {
                cardView.backgroundImage = UIImage(data: imageData)
                cardView.textColor = cardView.backgroundImage?.averageColor?.generateStaticTextColor() ?? .black
            }
            cardView.tintColor = .systemOrange
            cardView.textColor = cardView.backgroundImage?.averageColor?.generateStaticTextColor() ?? .black
        }
        else {
            cardView.title = "No Wish Item"
            cardView.itemTitle = "Please add"
            cardView.itemSubtitle = "a new wish item"
            cardView.buttonText = "0%"
            cardView.backgroundColor = .white
            cardView.backgroundImage = nil
            cardView.tintColor = .gray
            cardView.textColor = .black
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
            card.titleSize = 23
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
