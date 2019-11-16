//
//  WishlistTableViewController.swift
//  iCrave
//
//  Created by Kevin Kim on 17/10/2019.
//  Copyright © 2019 Kevin Kim. All rights reserved.
//

import UIKit
import SafariServices
import Cards

class WishlistTableViewController: UITableViewController {
    
    var wishlist: [WishItem] = WishItem.getAll()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 250
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        wishlist = WishItem.getAll()
        tableView.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return wishlist.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WishItemCell", for: indexPath) as! WishlistTableViewCell

        // Configure the cell...
        let item = wishlist[indexPath.row]
        cell.cardView.title = "Title"
        cell.cardView.itemTitle = "0 \(item.currency!)"
        cell.cardView.itemSubtitle = "out of 0 \(item.currency!)"
        // Load Object
        cell.cardView.title = item.name!
        cell.cardView.itemTitle = "0 \(item.currency!)"
        cell.cardView.itemSubtitle = "out of \(decimalToString(item.price!)) \(item.currency!)"
        cell.cardView.backgroundColor = .white
        cell.cardView.backgroundImage = nil
        cell.cardView.tintColor = .gray
        cell.cardView.textColor = .black
        if let imageData = item.image {
            cell.cardView.backgroundImage = UIImage(data: imageData)
            cell.cardView.textColor = cell.cardView.backgroundImage?.averageColor?.generateStaticTextColor() ?? .black
        }
        if item.saving {
            cell.cardView.tintColor = .systemOrange
        }
        cell.cardView.setNeedsDisplay()
        
        let wishlistDetailTap = UITapGestureRecognizer(target: self, action: #selector(wishlistDetailView(sender:)))
        cell.cardView.addGestureRecognizer(wishlistDetailTap)
        
        // 50 spaces added for flexible constraints - Cards bug
        cell.cardView.title += "                                             "
        cell.cardView.itemTitle += "                                             "
        cell.cardView.itemSubtitle += "                                             "

        return cell
    }
    
    @objc func wishlistDetailView(sender: UIGestureRecognizer) {
        let cardView = sender.view! as! CardHighlight
        let address = "http://www.google.com/search?q=\(cardView.title)"
        guard let encodeAddress = address.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }
        guard let url = URL(string: encodeAddress) else { return }
        let svc = SFSafariViewController(url: url)
        present(svc, animated: true, completion: nil)
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
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    */
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let item = self.wishlist[indexPath.row]
        
        let deleteAction = UIContextualAction(style: .destructive, title:  "Delete", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            WishItem.delete(wishItem: item)
            self.wishlist.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            success(true)
        })
        let editAction = UIContextualAction(style: .normal, title:  "Edit", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            self.performSegue(withIdentifier: "EditWishItem", sender: item)
            success(true)
        })
        return UISwipeActionsConfiguration(actions:[deleteAction, editAction])
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

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "EditWishItem" {
            if let destinationVC = segue.destination as? EditWishlistTableViewController {
                destinationVC.wishItem = sender as? WishItem
            }
        }
    }

}
