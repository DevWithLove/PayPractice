//
//  RateDetailView.swift
//  PayPayPractice
//
//  Created by Tony Mu on 23/08/22.
//

import SwiftUI

struct RateDetail {
    let name: String
    let title: String
    let subtitle: String
}

struct RateDetailView: View {
    let detail: RateDetail
    var body: some View {
        Group {
            HStack {
                Text(detail.name)
                    .font(.title)
                Spacer()
                VStack(alignment: .leading, spacing: 5) {
                    Text(detail.title)
                        .font(.title2)
                    Text(detail.subtitle)
                        .font(.subheadline)
                }
            }.padding(8)
        }
        .frame(maxWidth:.infinity, alignment: .leading)
        .background(Color.white)
        .cornerRadius(8)
        .shadow(color: Color.black.opacity(0.2), radius: 10, x: 1, y: 1)
    }
}

struct CurrencyDetailView_Previews: PreviewProvider {
    static var previews: some View {
        RateDetailView(detail: RateDetail(name: "NZD",
                                                  title: "$ 101,814.02",
                                                  subtitle: "1 USD = 1.6 NZD"))
    }
}
