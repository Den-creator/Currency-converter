//
//  ViewController.swift
//  Currency-converter
//
//  Created by Ден on 24.02.2020.
//  Copyright © 2020 Ден. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var textFielForQuantity: UITextField!
    @IBOutlet weak var currencyPicker: UIPickerView!
    @IBOutlet weak var labelOfResult: UILabel!
    
    var currencyManager = CurrencyManager()
    var device = UIDevice()
    var selectedCurrency = "USD"
    var iPad = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textFielForQuantity.layer.cornerRadius = view.frame.height / 35
        
        currencyPicker.dataSource = self
        currencyPicker.delegate = self
        currencyManager.delegate = self
        textFielForQuantity.delegate = self
        
        if device.model == C.iPad {iPad = true}
    }
    
    
}


//MARK: - UIPickerViewDataSource

extension ViewController: UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return currencyManager.currencyArray.count
    }
    
}


//MARK: - UIPickerViewDelegate

extension ViewController: UIPickerViewDelegate {
    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedCurrency = currencyManager.currencyArray[row]
        currencyManager.getSelectedCurrency(for: selectedCurrency)
        currencyManager.getCurrencyPrice(for: selectedCurrency)
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        var pickerLabel = UILabel()
        if let v = view as? UILabel { pickerLabel = v }
        
        if iPad {
            pickerLabel.font = UIFont (name: C.didot, size: 50)
        } else {
            pickerLabel.font = UIFont (name: C.didot, size: 25)
            
        }
        
        pickerLabel.textColor = #colorLiteral(red: 0.9607720971, green: 0.8015490174, blue: 0.6576380134, alpha: 1)
        pickerLabel.text =  currencyManager.currencyArray[row]
        pickerLabel.textAlignment = .center
        return pickerLabel
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        
        if iPad { return 60 }
        else { return 25 }
        
    }
    
}



//MARK: - CurrencyManagerDelegate

extension ViewController: CurrencyManagerDelegate {
    
    func didUpdatePrice(price: Double) {
        
        DispatchQueue.main.async {
            
            if let quantityOfCurrency = self.textFielForQuantity.text {
                let doubleValue = (quantityOfCurrency as NSString).doubleValue
                let result = doubleValue * price
                let resultString = String(format: "%.2f", result)
                self.labelOfResult.text = resultString + " " + C.uah
            } else {
                self.labelOfResult.text = "0" + " " + C.uah
            }
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
    
    
}

//MARK: - UITextFieldDelegate

extension ViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        currencyManager.getSelectedCurrency(for: selectedCurrency)
        currencyManager.getCurrencyPrice(for: selectedCurrency)
    }
}


