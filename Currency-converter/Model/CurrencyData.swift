//
//  CurrencyData.swift
//  Currency-converter
//
//  Created by Ден on 25.02.2020.
//  Copyright © 2020 Ден. All rights reserved.
//

import Foundation

struct CurrencyData: Codable {
    let rates: Rates
}

struct Rates: Codable {
    let UAH, EUR, PLN, RUB, USD : Double
}

