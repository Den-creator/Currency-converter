//
//  CurrencyManager.swift
//  Currency-converter
//
//  Created by Ден on 25.02.2020.
//  Copyright © 2020 Ден. All rights reserved.
//

import Foundation


protocol CurrencyManagerDelegate {
    func didUpdatePrice(price: Double)
    func didFailWithError(error: Error)
}

struct CurrencyManager {
    
    var selectedCurrency = C.usd
    
    var delegate: CurrencyManagerDelegate?
    
    let baseURL = C.baseURL
    let apiKey = C.apiKey
    let currencyArray = [C.usd, C.eur, C.rub, C.pln, C.cny, C.gbp, C.chf, C.jpy, C.aud]
    
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
                        self.delegate?.didUpdatePrice(price: currencyPrice)
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
            case C.usd:
                let usdToSelectedCurrency = decodedData.rates.USD
                return usdToUAH / usdToSelectedCurrency
            case C.eur:
                let usdToSelectedCurrency = decodedData.rates.EUR
                return usdToUAH / usdToSelectedCurrency
            case C.rub:
                let usdToSelectedCurrency = decodedData.rates.RUB
                return usdToUAH / usdToSelectedCurrency
            case C.pln:
                let usdToSelectedCurrency = decodedData.rates.PLN
                return usdToUAH / usdToSelectedCurrency
            case C.cny:
                let usdToSelectedCurrency = decodedData.rates.CNY
                return usdToUAH / usdToSelectedCurrency
            case C.gbp:
                let usdToSelectedCurrency = decodedData.rates.GBP
                return usdToUAH / usdToSelectedCurrency
            case C.chf:
                let usdToSelectedCurrency = decodedData.rates.CHF
                return usdToUAH / usdToSelectedCurrency
            case C.jpy:
                let usdToSelectedCurrency = decodedData.rates.JPY
                return usdToUAH / usdToSelectedCurrency
            case C.aud:
                let usdToSelectedCurrency = decodedData.rates.AUD
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
