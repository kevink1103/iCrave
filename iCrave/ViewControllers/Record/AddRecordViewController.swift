//
//  AddRecordViewController.swift
//  iCrave
//
//  Created by Kevin Kim on 17/10/2019.
//  Copyright © 2019 Kevin Kim. All rights reserved.
//

import UIKit
import IntentsUI

class AddRecordViewController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    let categories: [Category] = Category.getAll()
    
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
        
        // Siri Button
        addSiriButton(to: view)
        
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
    }
    
    func addSiriButton(to view: UIView) {
        let button = INUIAddVoiceShortcutButton(style: .automaticOutline)
        
        let intent = RecordIntent()
        intent.suggestedInvocationPhrase = "Record Spending"
        intent.amount = 0
        intent.category = nil
        
        button.shortcut = INShortcut(intent: intent )
        button.delegate = self
        
        button.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(button)
        view.centerXAnchor.constraint(equalTo: button.centerXAnchor).isActive = true
        addButton.topAnchor.constraint(equalTo: button.bottomAnchor, constant: 10).isActive = true
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
    
    @IBAction func addPressed(_ sender: Any) {
        let currency = SharedUserDefaults.shared.getCurrency()
        if currency.count == 0 {
            let alert = UIAlertController(title: "No Currency", message: "Set currency in Settings.", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .cancel)
            ok.setValue(UIColor.systemOrange, forKey: "titleTextColor")
            alert.addAction(ok)
            present(alert, animated:true, completion: nil)
            return
        }
        
        if let amountText = amountField.text, amountText.count > 0, let amount = Decimal(string: amountText) {
            let category = categories[categoryPicker.selectedRow(inComponent: 0)]
            Record.create(in: category, timestamp: datePicker.date, amount: amount, currency: currency)
            self.dismiss(animated: true, completion: {
                NotificationCenter.default.post(name: Notification.Name("HomeRefresh"), object: nil)
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

extension AddRecordViewController: INUIAddVoiceShortcutButtonDelegate {
    func present(_ addVoiceShortcutViewController: INUIAddVoiceShortcutViewController, for addVoiceShortcutButton: INUIAddVoiceShortcutButton) {
        addVoiceShortcutViewController.delegate = self
        addVoiceShortcutViewController.modalPresentationStyle = .formSheet
        present(addVoiceShortcutViewController, animated: true, completion: nil)
    }
    func present(_ editVoiceShortcutViewController: INUIEditVoiceShortcutViewController, for addVoiceShortcutButton: INUIAddVoiceShortcutButton) {
        editVoiceShortcutViewController.delegate = self
        editVoiceShortcutViewController.modalPresentationStyle = .formSheet
        present(editVoiceShortcutViewController, animated: true, completion: nil)
    }
}

extension AddRecordViewController: INUIAddVoiceShortcutViewControllerDelegate {
    func addVoiceShortcutViewController(_ controller: INUIAddVoiceShortcutViewController, didFinishWith voiceShortcut: INVoiceShortcut?, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
    func addVoiceShortcutViewControllerDidCancel(_ controller: INUIAddVoiceShortcutViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
}

extension AddRecordViewController: INUIEditVoiceShortcutViewControllerDelegate {
    func editVoiceShortcutViewController(_ controller: INUIEditVoiceShortcutViewController, didUpdate voiceShortcut: INVoiceShortcut?, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
    func editVoiceShortcutViewController(_ controller: INUIEditVoiceShortcutViewController, didDeleteVoiceShortcutWithIdentifier deletedVoiceShortcutIdentifier: UUID) {
        controller.dismiss(animated: true, completion: nil)
    }
    func editVoiceShortcutViewControllerDidCancel(_ controller: INUIEditVoiceShortcutViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
}
