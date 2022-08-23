//
//  CurrencyApi.swift
//  PayPayPractice
//
//  Created by Tony Mu on 23/08/22.
//

import Foundation

enum CurrencyApi {
    // subs
    case fetchLatest(String)

    private var urlString: String {
        let base = "https://openexchangerates.org/api/"
        let appId = "8348b659a30941a7a8b2c0d629a377b2"
        switch self {
        case .fetchLatest(let baseCurrency):
            return "\(base)/latest.json?app_id=\(appId)&base=\(baseCurrency)"
        }
    }

    private var method: HttpMethod {
        switch self {
        case .fetchLatest:
            return .get
        }
    }

    func request(withBody body: Data? = nil) throws -> URLRequest {
        guard let url = URL(string: urlString) else {
            throw ApiError.urlError("invalid url: \(urlString)")
        }
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.httpBody = body
        return request
    }
}

extension HTTPURLResponse {
    var isValidResponse: Bool {
        return 200..<299 ~= statusCode
    }
}

extension URLRequest {
    func send<T: Decodable>() async throws -> T {
        do {
            let (data, response)  = try await URLSession.shared.data(for: self, delegate: nil)

            guard let response = response as? HTTPURLResponse, response.isValidResponse else {
                throw ApiError.invalidedResponse
            }

            let value = try JSONDecoder().decode(T.self, from: data)
            return value
        } catch is DecodingError {
            throw ApiError.decodingError
        } catch {
            throw ApiError.unknown(error)
        }
    }
}



