//
//  CurrencyManager.swift
//  Currency-converter
//
//  Created by Ден on 25.02.2020.
//  Copyright © 2020 Ден. All rights reserved.
//

import Foundation


protocol CurrencyManagerDelegate {
    func didUpdatePrice(price: String)
    func didFailWithError(error: Error)
}

struct CurrencyManager {
    
    var selectedCurrency = "USD"
    
    var delegate: CurrencyManagerDelegate?
    
    let baseURL = "https://openexchangerates.org/api/latest.json?app_id="
    let apiKey = "3d9f1644b6d94f658661c9e85eb82416"
    let currencyArray = ["USD", "EUR", "PLN", "RUB"]
    
    mutating func getSelectedCurrency(for currency: String) {
        selectedCurrency = currency
    }
    
    func getCurrencyPrice(for currency: String) {
                
        let urlString = baseURL + apiKey
        print(urlString)
        
        if let url = URL(string: urlString) {
            
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                if let safeData = data {
                    if let currencyPrice = self.parseJSON(safeData) {
                        let priceString = String(format: "%.2f", currencyPrice)
                        self.delegate?.didUpdatePrice(price: priceString)
                    }
                    
                }
            }
            task.resume()
        }
        
        
    }
    
    
    func parseJSON(_ data: Data) -> Double? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(CurrencyData.self, from: data)
            
            let usdToUAH = decodedData.rates.UAH
            
            switch selectedCurrency {
            case "USD":
                let usdToSelectedCurrency = decodedData.rates.USD
                return usdToUAH / usdToSelectedCurrency
            case "EUR":
                let usdToSelectedCurrency = decodedData.rates.EUR
                return usdToUAH / usdToSelectedCurrency
            case "PLN":
                let usdToSelectedCurrency = decodedData.rates.PLN
                return usdToUAH / usdToSelectedCurrency
            case "RUB":
                let usdToSelectedCurrency = decodedData.rates.RUB
                return usdToUAH / usdToSelectedCurrency
            default:
                let usdToSelectedCurrency = decodedData.rates.USD
                return usdToUAH / usdToSelectedCurrency
            }
            
            } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
        
    }
    
}
