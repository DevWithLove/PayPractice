//
//  LatestCurrencyDto.swift
//  PayPayPractice
//
//  Created by Tony Mu on 23/08/22.
//

import Foundation

struct LatestCurrencyDto: Decodable {
    let timestamp: Int
    let base: String
    let rates: [String: Decimal]
}

extension LatestCurrencyDto {
    func convertCurrency(from: Currency, to: Currency, amount: Decimal = 1) -> Decimal? {
        guard let fromCurrencyRate = rates[from.code],
              let toCurrencyRate = rates[to.code] else { return nil }

        // The rates list based on USD
        if from == .USD { return toCurrencyRate * amount }
        if to == .USD { return amount / fromCurrencyRate }

        // Otherwise, convert currency based on USD rate
        return (amount / fromCurrencyRate) * toCurrencyRate
    }
}
