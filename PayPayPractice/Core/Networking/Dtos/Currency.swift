//
//  Currency.swift
//  PayPayPractice
//
//  Created by Tony Mu on 23/08/22.
//

import Foundation

enum Currency: String, CaseIterable {
    case USD
    case NZD
    case KRW
    case JPY
    case EUR
    case AUD
    case GBP
    case CAD
    case CNY

    var code: String {
        return rawValue
    }
}
