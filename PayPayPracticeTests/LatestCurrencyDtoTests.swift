//
//  PayPayPracticeTests.swift
//  PayPayPracticeTests
//
//  Created by Tony Mu on 23/08/22.
//

import XCTest
@testable import PayPayPractice

class LatestCurrencyDtoTests: XCTestCase {

    let rates: [String: Decimal] = ["NZD": 1.6190,
                                    "USD": 1,
                                    "JPY": 137.3643]

    func testConvert_USD_to_NZD() throws {
        // Arrange
        let dto = LatestCurrencyDto(timestamp: 1231231, base: "USD", rates: rates)

        // Act
        let amount = dto.convertCurrency(from: .USD, to: .NZD, amount: 100)?.toCurrency(for: .NZD)

        // Assert
        XCTAssertEqual(amount, "NZ$161.90")
    }

    func testConvert_NZD_to_USD() throws {
        // Arrange
        let dto = LatestCurrencyDto(timestamp: 1231231, base: "USD", rates: rates)

        // Act
        let amount = dto.convertCurrency(from: .NZD, to: .USD, amount: 100)?.toCurrency(for: .USD)

        // Assert
        XCTAssertEqual(amount, "$61.77")
    }

    func testConvert_NZD_to_JPY() throws {
        // Arrange
        let dto = LatestCurrencyDto(timestamp: 1231231, base: "USD", rates: rates)

        // Act
        let amount = dto.convertCurrency(from: .NZD, to: .JPY, amount: 100)?.toCurrency(for: .JPY)

        // Assert
        XCTAssertEqual(amount, "¥8,484.52")
    }
}

