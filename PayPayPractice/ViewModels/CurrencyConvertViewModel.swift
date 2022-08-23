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
    private let currencyCacheManager: CurrencyStorage
    private var latestCurrency: LatestCurrencyDto?

    // MARK: - View Properties
    /// User is able to select rates list
    let defaultCurrencyList = Currency.allCases
    /// Currency detail list
    @Published var currencies = [RateDetail]()
    /// User entered amount
    @Published var amount: Double? = nil
    /// User selected base currency
    @Published var selectedCurrency: Currency = .USD

    // MARK: - Init
    init(currencyRepository: CurrencyRepository = DefaultCurrencyRepository(),
         currencyCacheManager: CurrencyStorage = DefaultCurrencyStorage()) {
        self.currencyRepository = currencyRepository
        self.currencyCacheManager = currencyCacheManager
    }

    @MainActor
    func loadData() async {
        // Try to get valid cached currency detail
        if let cachedLatestCurrency = getCachedLatestCurrency() {
            latestCurrency = cachedLatestCurrency
            updateRatesDetail()
            return
        }

        // Otherwise, fetching currency remotely
        await fetchLatestCurrency()
    }

    /// Update currency info based on user's input
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
    /// Fetch currency from API
    @MainActor
    func fetchLatestCurrency() async {
        do {
            let result = try await currencyRepository.fetchLatest(for: .USD)
            latestCurrency = result
            // Update the view
            updateRatesDetail()
            // Store the latest result to cache
            try? currencyCacheManager.write(result)
        } catch {
            // Use cached data if there is any
            if let cachedLatestCurrency = getCachedLatestCurrency() {
                latestCurrency = cachedLatestCurrency
                updateRatesDetail()
                return
            }
            // TODO: Otherwise display error message to user
        }
    }

    /// Get cached currency
    func getCachedLatestCurrency() -> LatestCurrencyDto? {
        guard let latestCurrency = try? currencyCacheManager.read(),
              !latestCurrency.isExpired else { return nil }
        return latestCurrency
    }

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
