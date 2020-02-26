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
    var selectedCurrency = "USD"
        
    override func viewDidLoad() {
        super.viewDidLoad()
        textFielForQuantity.layer.cornerRadius = 20
       
        currencyPicker.dataSource = self
        currencyPicker.delegate = self
        currencyManager.delegate = self
        textFielForQuantity.delegate = self
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
        
            if textFielForQuantity.frame.height == 100 {
                pickerLabel.font = UIFont (name: "Didot", size: 25)
            } else if textFielForQuantity.frame.height == 200 {
                pickerLabel.font = UIFont (name: "Didot", size: 50)
            }
        
        pickerLabel.textColor = #colorLiteral(red: 0.9607720971, green: 0.8015490174, blue: 0.6576380134, alpha: 1)
        pickerLabel.text =  currencyManager.currencyArray[row]
        pickerLabel.textAlignment = .center
        return pickerLabel
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        
        if textFielForQuantity.frame.height == 200 { return 60 }
        else { return 25 }
    }

}



//MARK: - CurrencyManagerDelegate

extension ViewController: CurrencyManagerDelegate {
    
    func didUpdatePrice(price: Double) {
        
        DispatchQueue.main.async {
            
            let quantityOfCurrency = NumberFormatter().number(from: self.textFielForQuantity.text!)
            
            if let number = quantityOfCurrency {
                let doubleValue = Double(truncating: number)
                let result = doubleValue * price
                let resultString = String(format: "%.2f", result)
                self.labelOfResult.text = resultString + " " + "UAH"
                
            }   else {
                self.labelOfResult.text = "0" + " " + "UAH"
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


