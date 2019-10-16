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
    var categories = [
        "Food": "red",
        "Octopus": "pink",
        "Supermarket": "green",
        "Shopping": "yellow"
    ]
    var wishlists = [
        ["timestamp": "1", "name": "iPhone 11 Pro", "price": "6000"],
        ["timestamp": "2", "name": "Fujifilm X-T3", "price": "10000"]
    ]
    var records = [
        ["timestamp": "1", "category": "Food", "amount": "50"],
        ["timestamp": "2", "category": "Octopus", "amount": "100"],
        ["timestamp": "3", "category": "Supermarket", "amount": "300"],
        ["timestamp": "4", "category": "Shopping", "amount": "1000"]
    ]
    
    @IBOutlet var cardView: CardHighlight!
    @IBOutlet var recordsScroll: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        drawRecords()
    }
    
    func drawRecords() {
        let buttonPadding: CGFloat = 10
        var xOffset: CGFloat = 20
        let height = recordsScroll.frame.height
        let width = height + 10
        
        var card = CardHighlight(frame: CGRect(x: xOffset, y: 0, width: width , height: height))
        let tap = UITapGestureRecognizer(target: self, action: #selector(showAddRecordView(sender:)))
        
        card.title = "Add\nRecord"
        card.itemTitle = ""
        card.itemSubtitle = ""
        card.buttonText = "➕"
        card.shadowColor = .white
        card.addGestureRecognizer(tap)
        
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
            card.shadowColor = .white
            card.backgroundColor = getUIColor(categories[records[i]["category"]!]!)
            //button.addTarget(self, action: #selector(btnTouch), for: UIControlEvents.touchUpInside)
            xOffset = xOffset + CGFloat(buttonPadding) + card.frame.size.width
            recordsScroll.addSubview(card)
        }
        recordsScroll.contentSize = CGSize(width: xOffset+10, height: recordsScroll.frame.height)
    }
    
    @objc func showAddRecordView(sender: UIGestureRecognizer) {
        performSegue(withIdentifier: "AddRecordSegue", sender: self)
    }
    
    func getUIColor(_ string: String) -> UIColor {
        switch (string) {
        case "red":
            return .red
        case "pink":
            return .systemPink
        case "green":
            return .green
        case "yellow":
            return .yellow
        default:
            return .white
        }
    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return CGFloat.leastNonzeroMagnitude
        }
        return CGFloat(1)
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 0 {
            return CGFloat.leastNonzeroMagnitude
        }
        return CGFloat(10)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension HomeViewController: CardDelegate {
    func cardDidTapInside(card: Card) {
        print("whatthefuck")
    }
}
