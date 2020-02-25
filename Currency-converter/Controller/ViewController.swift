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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textField.layer.cornerRadius = 20
        currencyPicker.dataSource = self
        currencyPicker.delegate = self
        currencyManager.delegate = self
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
        let selectedCurrency = currencyManager.currencyArray[row]
        currencyManager.getSelectedCurrency(for: selectedCurrency)
        currencyManager.getCurrencyPrice(for: selectedCurrency)
    }
}


//MARK: - CurrencyManagerDelegate

extension ViewController: CurrencyManagerDelegate {
    
    func didUpdatePrice(price: String) {        
        DispatchQueue.main.async {
            self.labelOfResult.text = price + " " + "UAH"
            }
        }
    
    func didFailWithError(error: Error) {
        print(error)
    }


}


