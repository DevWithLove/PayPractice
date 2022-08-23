//
//  CurrencyConvertViewModelTests.swift
//  PayPayPracticeTests
//
//  Created by Tony Mu on 24/08/22.
//

import XCTest
@testable import PayPayPractice

class CurrencyConvertViewModelTests: XCTestCase {

    /// Load data from api if there is no valided cached data
    func testLoad_Data_from_API() async throws {
        // Aranage
        let mockStorage = MockCurrencyStorage()
        let rates: [String:Decimal] = ["USD": 1, "NZD": 1.6190]
        let mockRepository = MockCurrencyRepository(expectedResult: LatestCurrencyDto.create(rates: rates))
        let viewModel = CurrencyConvertViewModel(currencyRepository: mockRepository, currencyCacheManager: mockStorage)

        // Act
        await viewModel.loadData()

        // Assert
        XCTAssertEqual(viewModel.currencies[0].name, "USD")
        XCTAssertEqual(viewModel.currencies[0].title, "$1.00")
        XCTAssertEqual(viewModel.currencies[0].subtitle, "")
        XCTAssertEqual(viewModel.currencies[1].name, "NZD")
        XCTAssertEqual(viewModel.currencies[1].title, "NZ$1.62")
        XCTAssertEqual(viewModel.currencies[1].subtitle, "1 USD = NZ$1.6190")
    }

    /// Load data from cached, if there is a valid cached data
    func testLoad_Data_from_valid_cached() async throws {
        // Aranage
        let cachedRates: [String:Decimal] = ["USD": 1, "NZD": 1.800]
        let fetchedTime = Date().addMinute(5) // last fetched on 5 mins ago
        let mockStorage = MockCurrencyStorage(expectedResult: LatestCurrencyDto.create(rates: cachedRates, fetchedTime: fetchedTime))

        let repositoryRates: [String:Decimal] = ["USD": 1, "NZD": 1.6190]
        let mockRepository = MockCurrencyRepository(expectedResult: LatestCurrencyDto.create(rates: repositoryRates))
        let viewModel = CurrencyConvertViewModel(currencyRepository: mockRepository, currencyCacheManager: mockStorage)

        // Act
        await viewModel.loadData()

        // Assert
        XCTAssertEqual(viewModel.currencies[1].name, "NZD")
        XCTAssertEqual(viewModel.currencies[1].title, "NZ$1.80")
        XCTAssertEqual(viewModel.currencies[1].subtitle, "1 USD = NZ$1.8000")
    }

    /// Load data from api, if there is the cached data is expired
    func testLoad_Data_from_api_when_cached_data_expired() async throws {
        // Aranage
        let cachedRates: [String:Decimal] = ["USD": 1, "NZD": 1.800]
        let fetchedTime = Date().addMinute(-35) // last fetched on 35 mins ago
        let mockStorage = MockCurrencyStorage(expectedResult: LatestCurrencyDto.create(rates: cachedRates, fetchedTime: fetchedTime))

        let repositoryRates: [String:Decimal] = ["USD": 1, "NZD": 1.6190]
        let mockRepository = MockCurrencyRepository(expectedResult: LatestCurrencyDto.create(rates: repositoryRates))
        let viewModel = CurrencyConvertViewModel(currencyRepository: mockRepository, currencyCacheManager: mockStorage)

        // Act
        await viewModel.loadData()

        // Assert
        XCTAssertEqual(viewModel.currencies[1].name, "NZD")
        XCTAssertEqual(viewModel.currencies[1].title, "NZ$1.62")
        XCTAssertEqual(viewModel.currencies[1].subtitle, "1 USD = NZ$1.6190")
    }

    /// Load data from cached, even the cached data is expired when API returns error
    func testLoad_Data_from_cached_when_api_returns_error() async throws {
        // Aranage
        let cachedRates: [String:Decimal] = ["USD": 1, "NZD": 1.800]
        let fetchedTime = Date().addMinute(-35) // last fetched on 35 mins ago
        let mockStorage = MockCurrencyStorage(expectedResult: LatestCurrencyDto.create(rates: cachedRates, fetchedTime: fetchedTime))

        let repositoryRates: [String:Decimal] = ["USD": 1, "NZD": 1.6190]
        let mockRepository = MockCurrencyRepository(expectedResult: LatestCurrencyDto.create(rates: repositoryRates),
                                                    expectedError: .invalidedResponse)
        let viewModel = CurrencyConvertViewModel(currencyRepository: mockRepository, currencyCacheManager: mockStorage)

        // Act
        await viewModel.loadData()

        // Assert
        XCTAssertEqual(viewModel.currencies[1].name, "NZD")
        XCTAssertEqual(viewModel.currencies[1].title, "NZ$1.80")
        XCTAssertEqual(viewModel.currencies[1].subtitle, "1 USD = NZ$1.8000")
    }
}

class MockCurrencyRepository: CurrencyRepository {
    private let expectedResult: LatestCurrencyDto
    private let expectedError: ApiError?

    init(expectedResult: LatestCurrencyDto, expectedError: ApiError? = nil) {
        self.expectedResult = expectedResult
        self.expectedError = expectedError
    }

    func fetchLatest(for baseCurrency: Currency) async throws -> LatestCurrencyDto {
        if let error = expectedError { throw error }
        return expectedResult
    }
}

class MockCurrencyStorage: CurrencyStorage {
    private var expectedResult: LatestCurrencyDto?
    private let expectedError: StorageError?

    init(expectedResult:LatestCurrencyDto? = nil, expectedError: StorageError? = nil) {
        self.expectedResult = expectedResult
        self.expectedError = expectedError
    }

    func write(_ currency: LatestCurrencyDto) throws {
        if let error = expectedError { throw error }
        self.expectedResult = currency
    }

    func read() throws -> LatestCurrencyDto? {
        if let error = expectedError { throw error }
        return self.expectedResult
    }
}

extension LatestCurrencyDto {
    static func create(rates: [String: Decimal],
                       fetchedTime: Date? = nil) -> LatestCurrencyDto {
        LatestCurrencyDto(timestamp: 1231231, base: "USD", rates: rates, fetchedTime: fetchedTime)
    }
}

extension Date {
    func addMinute(_ minutes: Int) -> Date {
        return Calendar.current.date(byAdding: .minute, value: minutes, to: self)!
    }
}
