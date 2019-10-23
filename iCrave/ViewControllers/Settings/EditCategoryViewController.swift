//
//  EditCategoryViewController.swift
//  iCrave
//
//  Created by Kevin Kim on 23/10/2019.
//  Copyright © 2019 Kevin Kim. All rights reserved.
//

import UIKit

class EditCategoryViewController: UIViewController, UITextFieldDelegate, UICollectionViewDelegate, UICollectionViewDataSource {

    let colors = ["red", "orange", "yellow", "green", "blue", "purple", "pink", "teal", "indigo", "gray", "black", "white"]
    var color = ""
    
    var category: Category? = nil

    @IBOutlet var titleField: UITextField!
    @IBOutlet var colorView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        
        titleField.text = category!.title
        color = category!.color!
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return colors.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ColorCell", for: indexPath)
        // Configure the cell
        cell.backgroundColor = colors[indexPath.row].getUIColor()
        cell.layer.borderWidth = 1.0
        cell.layer.borderColor = UIColor.gray.cgColor
        if color == colors[indexPath.row] {
            colorView.selectItem(at: indexPath, animated: true, scrollPosition: .left)
            cell.isSelected = true
            cell.layer.borderWidth = 5.0
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.layer.borderWidth = 5.0
        cell?.layer.borderColor = UIColor.gray.cgColor
        color = colors[indexPath.row]
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.layer.borderWidth = 1.0
        cell?.layer.borderColor = UIColor.gray.cgColor
    }
    
    @IBAction func cancel(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func updatePressed(_ sender: UIButton) {
        if let title = titleField.text {
            if title.count > 0  && color.count > 0 {
                Category.update(category: category!, title: title, color: color)
                self.dismiss(animated: true, completion: {
                    NotificationCenter.default.post(name: Notification.Name("CategoryRefresh"), object: nil)
                })
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
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