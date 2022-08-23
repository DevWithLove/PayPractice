//
//  CurrencyStorage.swift
//  PayPayPractice
//
//  Created by Tony Mu on 23/08/22.
//

import Foundation

protocol CurrencyStorage {
    func write(_ currency: LatestCurrencyDto) throws
    func read() throws -> LatestCurrencyDto?
}

class DefaultCurrencyStorage: CurrencyStorage {
    private let jsonFile = "latestCurrency.json"
    private var fileURL: URL {
        get throws {
            try FileManager.default
                .url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
                .appendingPathComponent(jsonFile)
        }
    }

    func write(_ currency: LatestCurrencyDto) throws {
        // Converte the currency with fetchedTime
        let data = currency.clone(with: Date())
        do {
            let fileURL = try fileURL
            try JSONEncoder().encode(data).write(to: fileURL)
        } catch {
            throw StorageError.failedWrtieData
        }
    }

    func read() throws -> LatestCurrencyDto? {
        do {
            let fileURL = try fileURL
            let data = try Data(contentsOf: fileURL)
            return try JSONDecoder().decode(LatestCurrencyDto.self, from: data)
        } catch {
            return nil
        }
    }
}

enum StorageError: Error {
    case failedWrtieData
    case failedReadData
}

private extension LatestCurrencyDto {
    func clone(with fetchedTime: Date) -> LatestCurrencyDto {
        LatestCurrencyDto(timestamp: timestamp, base: base, rates: rates, fetchedTime: fetchedTime)
    }
}
