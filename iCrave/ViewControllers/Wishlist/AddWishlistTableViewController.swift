//
//  AddWishlistTableViewController.swift
//  iCrave
//
//  Created by Kevin Kim on 17/10/2019.
//  Copyright © 2019 Kevin Kim. All rights reserved.
//

import UIKit
import Cards

class AddWishlistTableViewController: UITableViewController, UITextFieldDelegate, ImagePickerDelegate {
    
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
        
        // Image Picker
        imagePicker = ImagePicker(presentationController: self, delegate: self)
    }
    
    func updatePreviewCard() {
        if let name = productName.text {
            if name.count > 0 {
                previewCard.title = name
            }
        }
        if let price = priceField.text {
            if price.count > 0 {
                if let priceDecimal = stringToDecimal(price) {
                    let currency = SharedUserDefaults.shared.getCurrency()
                    previewCard.itemTitle = "0 \(currency)"
                    previewCard.itemSubtitle = "out of \(decimalToString(priceDecimal)) \(currency)"
                }
            }
        }
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
    
    @IBAction func addPressed(_ sender: Any) {
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
                        if !WishItem.checkAnySavingOn() {
                            WishItem.create(name: name, price: priceDecimal, currency: currency, saving: savingSwitch.isOn, image: imageData)
                            navigationController?.popViewController(animated: true)
                            return
                        }
                        else {
                            let alert = UIAlertController(title: "Already Saving", message: "You already have a wish item currently saving for.", preferredStyle: .alert)
                            let ok = UIAlertAction(title: "OK", style: .cancel)
                            ok.setValue(UIColor.systemOrange, forKey: "titleTextColor")
                            alert.addAction(ok)
                            present(alert, animated:true, completion: nil)
                            return
                        }
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
