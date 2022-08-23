//
//  LatestCurrencyResultDto.swift
//  PayPayPractice
//
//  Created by Tony Mu on 23/08/22.
//

import Foundation

struct LatestCurrencyResultDto: Decodable {
    let timestamp: Int
    let base: String
    let rates: [String: Decimal]
}
