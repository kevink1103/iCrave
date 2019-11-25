//
//  EditWishlistTableViewController.swift
//  iCrave
//
//  Created by Kevin Kim on 15/11/2019.
//  Copyright © 2019 Kevin Kim. All rights reserved.
//

import UIKit
import Cards

class EditWishlistTableViewController: UITableViewController, UITextFieldDelegate, ImagePickerDelegate {

    var wishItem: WishItem? = nil
    var imagePicker: ImagePicker!

    @IBOutlet var productName: UITextField!
    @IBOutlet var priceField: UITextField!
    @IBOutlet var savingSwitch: UISwitch!
    @IBOutlet var previewCard: CardHighlight!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        
        productName.addTarget(self, action: #selector(textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        priceField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: UIControl.Event.editingChanged)

        // Amount Placeholder
        let currency = SharedUserDefaults.shared.getCurrency()
        if currency.count > 0 {
            priceField.placeholder = currency
        }
        else {
            priceField.placeholder = "Currency not set"
        }
        
        // Empty Card
        previewCard.title = "Title"
        previewCard.itemTitle = "0 \(currency)"
        previewCard.itemSubtitle = "out of 0 \(currency)"
        previewCard.backgroundImage = nil
        previewCard.backgroundColor = .systemBackground
        previewCard.textColor = UIColor(named: "DarkText")!
        previewCard.tintColor = .gray
        // 50 spaces added for flexible constraints - Cards bug
        previewCard.title += "                                             "
        previewCard.itemTitle += "                                             "
        previewCard.itemSubtitle += "                                             "
        
        // Image Picker
        imagePicker = ImagePicker(presentationController: self, delegate: self)
        
        // Load Object
        if let item = wishItem {
            productName.text = item.name!
            priceField.text = item.price!.stringValue
            savingSwitch.isOn = item.saving
            if let imageData = item.image {
                previewCard.backgroundImage = UIImage(data: imageData)
                previewCard.textColor = previewCard.backgroundImage?.averageColor?.generateStaticTextColor() ?? .black
                previewCard.setNeedsDisplay()
            }
            if item.achieved {
                productName.isEnabled = false
                priceField.isEnabled = false
                savingSwitch.isOn = false
                savingSwitch.isEnabled = false
            }
            updatePreviewCard()
        }
    }
    
    func updatePreviewCard() {
        if let name = productName.text {
            previewCard.title = "Title"
            if name.count > 0 {
                previewCard.title = name
            }
        }
        if let price = priceField.text {
            let currency = SharedUserDefaults.shared.getCurrency()
            previewCard.itemTitle = "0 \(currency)"
            previewCard.itemSubtitle = "out of 0 \(currency)"
            
            if price.count > 0 {
                if let priceDecimal = stringToDecimal(price) {
                    previewCard.itemSubtitle = "out of \(decimalToString(priceDecimal)) \(currency)"
                }
            }
        }
        // 50 spaces added for flexible constraints - Cards bug
        previewCard.title += "                                             "
        previewCard.itemTitle += "                                             "
        previewCard.itemSubtitle += "                                             "
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        updatePreviewCard()
    }
    
    func didSelect(image: UIImage?) {
        if let selectedImage = image {
            previewCard.backgroundImage = selectedImage
            previewCard.textColor = previewCard.backgroundImage?.averageColor?.generateStaticTextColor() ?? .white
            previewCard.setNeedsDisplay()
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNonzeroMagnitude
    }

    @IBAction func uploadImage(_ sender: UIButton) {
        imagePicker.present(from: sender)
    }
    
    @IBAction func updatePressed(_ sender: Any) {
        if let name = productName.text, let price = priceField.text {
            if name.count > 0 && price.count > 0 {
                if let priceDecimal = stringToDecimal(price) {
                    let currency = SharedUserDefaults.shared.getCurrency()
                    if currency.count > 0 {
                        var imageData: Data? = nil
                        if let bgImage = previewCard.backgroundImage {
                            if bgImage.pngData() != nil {
                                imageData = bgImage.pngData()
                            }
                            else if bgImage.jpegData(compressionQuality: 20) != nil {
                                imageData = bgImage.jpegData(compressionQuality: 20)
                            }
                            else {
                                print("image not supported")
                            }
                        }
                        if savingSwitch.isOn && !wishItem!.saving && WishItem.checkAnySavingOn() {
                            let alert = UIAlertController(title: "Already Saving", message: "You already have a wish item currently saving for.", preferredStyle: .alert)
                            let ok = UIAlertAction(title: "OK", style: .cancel)
                            ok.setValue(UIColor.systemOrange, forKey: "titleTextColor")
                            alert.addAction(ok)
                            present(alert, animated:true, completion: nil)
                            return
                        }
                        WishItem.update(wishItem: wishItem!, name: name, price: priceDecimal, currency: currency, saving: savingSwitch.isOn, image: imageData, achieved: wishItem!.achieved)
                        navigationController?.popViewController(animated: true)
                        return
                    }
                    else {
                        let alert = UIAlertController(title: "No Currency", message: "Set currency in Settings.", preferredStyle: .alert)
                        let ok = UIAlertAction(title: "OK", style: .cancel)
                        ok.setValue(UIColor.systemOrange, forKey: "titleTextColor")
                        alert.addAction(ok)
                        present(alert, animated:true, completion: nil)
                        return
                    }
                }
            }
        }
        let alert = UIAlertController(title: "Check Inputs", message: "Please check name and price.", preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .cancel)
        ok.setValue(UIColor.systemOrange, forKey: "titleTextColor")
        alert.addAction(ok)
        present(alert, animated:true, completion: nil)
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
