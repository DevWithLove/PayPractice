//
//  LatestCurrencyDto.swift
//  PayPayPractice
//
//  Created by Tony Mu on 23/08/22.
//

import Foundation

struct LatestCurrencyDto: Codable {
    let timestamp: Double
    let base: String
    let rates: [String: Decimal]
    let fetchedTime: Date?
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

    var isExpired: Bool {
        guard let fetchedTime = fetchedTime else { return true }
        let diffComponents = Calendar.current.dateComponents([.minute], from: fetchedTime, to: Date())
        if let minute = diffComponents.minute  {
            return minute > 30
        }
        return true
    }
}
