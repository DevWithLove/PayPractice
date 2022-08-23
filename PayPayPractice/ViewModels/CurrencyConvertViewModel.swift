//
//  CurrencyConvertViewModel.swift
//  PayPayPractice
//
//  Created by Tony Mu on 23/08/22.
//

import Foundation

class CurrencyConvertViewModel: ObservableObject {

    // MARK: - Private properties
    private let currencyRepository: CurrencyRepository
    private var rates = [String: Decimal]()

    // MARK: - View Properties
    /// User is able to select rates list
    let defaultCurrencyList = ["USD","NZD","KRW","JPY","EUR","AUD","GBP","CAD","CNY"]
    /// Currency detail list
    @Published var currencies = [RateDetail]()
    @Published var amount: Double? = nil
    @Published var selectedCurrency: String = "USD"

    init(currencyRepository: CurrencyRepository = DefaultCurrencyRepository()) {
        self.currencyRepository = currencyRepository
    }

    @MainActor
    func fetchLatestCurrency() async {
        do {
            let result = try await currencyRepository.fetchLatest(for: "USD")
            rates = result.rates
            currencies = getDefaultRatesDetail(from: result.rates)
        } catch {
            // TODO: error handling
            print(error)
        }
    }
}

// MARK: - Private Helpers
private extension CurrencyConvertViewModel {
    func getDefaultRatesDetail(from rates:[String: Decimal]) -> [RateDetail] {
        return defaultCurrencyList.compactMap { currency in
            if let rate = rates[currency] {
                return RateDetail(name: currency,
                                  title: rate.toCurrency(for: currency),
                                  subtitle: "")
            }
            return nil
        }
    }
}



