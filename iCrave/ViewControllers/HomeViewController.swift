//
//  HomeViewController.swift
//  iCrave
//
//  Created by Kevin Kim on 16/10/2019.
//  Copyright © 2019 Kevin Kim. All rights reserved.
//

import UIKit
import Cards

class HomeViewController: UITableViewController {
    
    // dummy data
    var categories = Category.getAll()
    // var wishlists = [
    //     ["timestamp": "1", "name": "iPhone 11 Pro", "price": "6000"],
    //     ["timestamp": "2", "name": "Fujifilm X-T3", "price": "10000"]
    // ]
    var records: [[String: String]] = [
        ["timestamp": "1", "category": "Food", "amount": "50"],
        ["timestamp": "2", "category": "Octopus", "amount": "100"],
        ["timestamp": "3", "category": "Supermarket", "amount": "300"],
        ["timestamp": "4", "category": "School", "amount": "2000"],
        ["timestamp": "5", "category": "Club", "amount": "3000"],
        ["timestamp": "6", "category": "Furniture", "amount": "6000"],
        ["timestamp": "7", "category": "Shopping", "amount": "500"],
        ["timestamp": "8", "category": "Vacation", "amount": "10000"],
        ["timestamp": "9", "category": "Hobby", "amount": "4000"],
        ["timestamp": "10", "category": "Gambling", "amount": "500"],
        ["timestamp": "11", "category": "Secret", "amount": "100"],
        ["timestamp": "12", "category": "Charity", "amount": "600"],
    ]
    
    @IBOutlet weak var cardView: CardHighlight!
    @IBOutlet weak var recordsScroll: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Category.deleteAll()
        // print(Category.getAll().count)
        // loadDummyCategories()
        // print(Category.getAll())
        // Category.deleteAll()
        // Category.delete(title: "Supermarket")
        // print(Category.getAll())
        // Category.delete(title: "what")
        // if let ori = Category.getObject(title: "Supermarket") {
        //     Category.update(category: ori, title: "HAHA", color: ori.color!)
        // }
        // print(Category.getAll())
        // print(Category.getAll().count)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        configureCardView()
        drawRecords()
    }
    
    func configureCardView() {
        cardView.textColor = (cardView.backgroundImage?.averageColor?.generateTextColor())!
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
        card.textColor = UIColor.systemBackground.generateTextColor()
        
        let addRecordTap = UITapGestureRecognizer(target: self, action: #selector(showAddRecordView(sender:)))
        card.addGestureRecognizer(addRecordTap)
        
        xOffset = xOffset + CGFloat(buttonPadding) + card.frame.size.width
        recordsScroll.addSubview(card)
        
        for i in 0..<records.count {
            card = CardHighlight(frame: CGRect(x: xOffset, y: 0, width: width , height: height))
            
            card.tag = i
            card.title = records[i]["category"]!
            card.titleSize = 23
            card.itemTitle = ""
            card.itemSubtitle = records[i]["amount"]! + " HKD"
            card.buttonText = ""
            card.shadowOpacity = 0
            card.backgroundColor = .systemBackground
            card.textColor = UIColor.systemBackground.generateTextColor()
            if let category = Category.getObject(title: records[i]["category"]!) {
                card.backgroundColor = category.color!.getUIColor()
                card.textColor = category.color!.getUIColor().generateTextColor()
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
        performSegue(withIdentifier: "WishlistDetailSegue", sender: self)
    }
    
    @objc func recentRecordClick(sender: UIGestureRecognizer) {
        let tag = sender.view!.tag
        print(tag)
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
        if segue.identifier == "WishlistDetailSegue" {
            if let vc = segue.destination as? WishlistDetailTableViewController {
                vc.navTitle = cardView.title
            }
        }
    }

}
