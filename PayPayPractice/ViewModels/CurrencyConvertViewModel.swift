//
//  CurrencyConvertViewModel.swift
//  PayPayPractice
//
//  Created by Tony Mu on 23/08/22.
//

import Foundation

class CurrencyConvertViewModel: ObservableObject {
    private let currencyRepository: CurrencyRepository

    init(currencyRepository: CurrencyRepository = DefaultCurrencyRepository()) {
        self.currencyRepository = currencyRepository
    }

    func fetchLatestCurrency() async {
        do {
            let result = try await currencyRepository.fetchLatest(for: "USD")
            print(result)
        } catch {
            print(error)
        }
    }
}
