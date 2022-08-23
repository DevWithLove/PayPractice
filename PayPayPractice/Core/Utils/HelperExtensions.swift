//
//  HelperExtensions.swift
//  PayPayPractice
//
//  Created by Tony Mu on 23/08/22.
//


import Foundation

extension Decimal {
    func toCurrency(for currency: Currency) -> String {
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 2
        formatter.currencyCode = currency.code
        formatter.numberStyle = .currency
        return formatter.string(for: self) ?? ""
    }
}
