//
//  HelperExtensions.swift
//  PayPayPractice
//
//  Created by Tony Mu on 23/08/22.
//


import Foundation

extension Decimal {
    func toCurrency(for currency: Currency, decimalPlace: Int = 2) -> String {
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = decimalPlace
        formatter.minimumFractionDigits = decimalPlace
        formatter.currencyCode = currency.code
        formatter.numberStyle = .currency
        return formatter.string(for: self) ?? ""
    }
}
