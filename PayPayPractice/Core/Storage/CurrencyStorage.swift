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

    func write(_ currency: LatestCurrencyDto) throws {
        do {
            let fileURL = try FileManager.default
                .url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
                .appendingPathComponent(jsonFile)

            try JSONEncoder().encode(currency).write(to: fileURL)
        } catch {
            throw StorageError.failedWrtieData
        }
    }

    func read() throws -> LatestCurrencyDto? {
        do {
            let fileURL = try FileManager.default
                .url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
                .appendingPathComponent(jsonFile)

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
