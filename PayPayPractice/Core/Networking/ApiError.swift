//
//  ApiError.swift
//  PayPayPractice
//
//  Created by Tony Mu on 23/08/22.
//

import Foundation

enum ApiError: Error, LocalizedError {
    case urlError(String)
    case notFound
    case invalidedResponse
    case unknown(Error)
    case decodingError

    var errorDescription: String? {
        switch self {
        case .urlError(let url):
           return "The endpoint URL is invalid: \(url)"
        case .notFound:
           return "No repository found"
        case .invalidedResponse:
            return "The API failed to issue a valid response"
        case .unknown(let error):
            return "Unknown error: \(error.localizedDescription)"
        case .decodingError:
            return "Decoding error"
        }
    }
}

enum HttpMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
}
