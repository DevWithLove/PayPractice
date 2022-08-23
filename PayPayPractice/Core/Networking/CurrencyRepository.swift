//
//  CurrencyRepository.swift
//  PayPayPractice
//
//  Created by Tony Mu on 23/08/22.
//

import Foundation

protocol CurrencyRepository {
    func fetchLatest(for baseCurrency: Currency) async throws -> LatestCurrencyDto
}

class DefaultCurrencyRepository: CurrencyRepository {
    func fetchLatest(for baseCurrency: Currency) async throws -> LatestCurrencyDto {
        let request = try CurrencyApi.fetchLatest(baseCurrency.code).request()
        return try await request.send()
    }
}
