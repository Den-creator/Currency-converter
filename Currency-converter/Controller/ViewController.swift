//
//  ViewController.swift
//  Currency-converter
//
//  Created by Ден on 24.02.2020.
//  Copyright © 2020 Ден. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var currencyPicker: UIPickerView!
    @IBOutlet weak var labelOfResult: UILabel!
    
    var currencyManager = CurrencyManager()
    var selectedCurrency = "USD"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textField.layer.cornerRadius = 20
        currencyPicker.setValue(#colorLiteral(red: 0.9607720971, green: 0.8015490174, blue: 0.6576380134, alpha: 1), forKey: "textColor")
        
        currencyPicker.dataSource = self
        currencyPicker.delegate = self
        currencyManager.delegate = self
        textField.delegate = self
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
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return currencyManager.currencyArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedCurrency = currencyManager.currencyArray[row]
        currencyManager.getSelectedCurrency(for: selectedCurrency)
        currencyManager.getCurrencyPrice(for: selectedCurrency)
    }
    
}


//MARK: - CurrencyManagerDelegate

extension ViewController: CurrencyManagerDelegate {
    
    func didUpdatePrice(price: Double) {
        
        DispatchQueue.main.async {
            
            if let quantityOfCurrency = Double(self.textField.text!) {
                let result = quantityOfCurrency * price
                let resultString = String(format: "%.2f", result)
                self.labelOfResult.text = resultString + " " + "UAH"
                
            } else {
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


