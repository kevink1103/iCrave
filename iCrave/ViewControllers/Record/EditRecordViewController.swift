//
//  EditRecordViewController.swift
//  iCrave
//
//  Created by Kevin Kim on 16/11/2019.
//  Copyright © 2019 Kevin Kim. All rights reserved.
//

import UIKit

class EditRecordViewController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    let categories: [Category] = Category.getAll()
    var record: Record? = nil
    
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var datePicker: UIDatePicker!
    @IBOutlet var amountField: UITextField!
    @IBOutlet var categoryPicker: UIPickerView!
    @IBOutlet var addButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        
        // Date Pikcer Limit
        datePicker.maximumDate = Date()
        
        // Amount Placeholder
        let currency = SharedUserDefaults.shared.getCurrency()
        if currency.count > 0 {
            amountField.placeholder = currency
        }
        else {
            amountField.placeholder = "Currency not set"
        }
        
        // Load Object
        if let recordObject = record {
            datePicker.date = recordObject.timestamp!
            amountField.text = recordObject.amount!.stringValue
            let index = categories.firstIndex(of: recordObject.category!)!
            categoryPicker.selectRow(index, inComponent: 0, animated: true)
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return categories.count
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 38
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var label = UILabel()
        if let v = view as? UILabel { label = v }
        label.font = UIFont(name: "Helvetica Neue", size: 25)
        label.text =  categories[row].title!
        label.textAlignment = .center
        label.backgroundColor = categories[row].color!.getUIColor()
        label.textColor = categories[row].color!.getUIColor().generateStaticTextColor()
        return label
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
    
    @IBAction func updatePressed(_ sender: Any) {
        let currency = SharedUserDefaults.shared.getCurrency()
        if currency.count == 0 {
            let alert = UIAlertController(title: "No Currency", message: "Set currency in Settings.", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .cancel)
            ok.setValue(UIColor.systemOrange, forKey: "titleTextColor")
            alert.addAction(ok)
            present(alert, animated:true, completion: nil)
        }
        
        if let amountText = amountField.text, amountText.count > 0, let amount = Decimal(string: amountText) {
            let category = categories[categoryPicker.selectedRow(inComponent: 0)]
            Record.update(record: record!, timestamp: datePicker.date, amount: amount, currency: currency)
            record!.category!.removeFromRecord(record!)
            category.addToRecord(record!)
            self.dismiss(animated: true, completion: {
                NotificationCenter.default.post(name: Notification.Name("RecordRefresh"), object: nil)
            })
        }
        else {
            let alert = UIAlertController(title: "Amount Error", message: "Please check amount input.", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .cancel)
            ok.setValue(UIColor.systemOrange, forKey: "titleTextColor")
            alert.addAction(ok)
            present(alert, animated:true, completion: nil)
        }
    }
    
    @IBAction func cancel(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
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
