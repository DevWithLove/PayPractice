//
//  CurrencyRepository.swift
//  PayPayPractice
//
//  Created by Tony Mu on 23/08/22.
//

import Foundation

protocol CurrencyRepository {
    func fetchLatest(for baseCurrency: String) async throws -> LatestCurrencyResultDto
}

class DefaultCurrencyRepository: CurrencyRepository {
    func fetchLatest(for baseCurrency: String = "USD") async throws -> LatestCurrencyResultDto {
        let request = try CurrencyApi.fetchLatest(baseCurrency).request()
        do {
            return try await request.send()
        } catch {
            throw ApiError.unknown(error)
        }
    }
}
