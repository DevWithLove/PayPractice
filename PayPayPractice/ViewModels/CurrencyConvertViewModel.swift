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
    private var latestCurrency: LatestCurrencyDto?

    // MARK: - View Properties
    /// User is able to select rates list
    let defaultCurrencyList = Currency.allCases
    /// Currency detail list
    @Published var currencies = [RateDetail]()
    @Published var amount: Double? = nil
    @Published var selectedCurrency: Currency = .USD

    init(currencyRepository: CurrencyRepository = DefaultCurrencyRepository()) {
        self.currencyRepository = currencyRepository
    }

    @MainActor
    func fetchLatestCurrency() async {
        do {
            let result = try await currencyRepository.fetchLatest(for: "USD")
            latestCurrency = result
            updateRatesDetail()
        } catch {
            // TODO: error handling
            print(error)
        }
    }

    func updateRatesDetail() {
        currencies = defaultCurrencyList.compactMap { currency in
            let amount = Decimal(self.amount ?? 1)
            return RateDetail(name: currency.code,
                              title: getConvertedAmount(from: selectedCurrency, to: currency, amount: amount),
                              subtitle: getRateInfo(from: selectedCurrency, to: currency))
        }
    }
}

// MARK: - Private Helpers
private extension CurrencyConvertViewModel {
    func getConvertedAmount(from base: Currency, to target: Currency, amount: Decimal) -> String {
        guard let exchangedAmount = self.latestCurrency?.convertCurrency(from: base, to: target, amount: amount) else { return "" }
        return exchangedAmount.toCurrency(for: target)
    }

    func getRateInfo(from base: Currency, to target: Currency) -> String {
        guard base != target,
              let rate = self.latestCurrency?.convertCurrency(from: base, to: target, amount: 1) else { return "" }
        return "1 \(base.code) = \(rate.toCurrency(for: target))"
    }
}
