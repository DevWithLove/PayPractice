//
//  ContentView.swift
//  PayPayPractice
//
//  Created by Tony Mu on 23/08/22.
//

import SwiftUI

struct CurrencyConvertView: View {
    
    var currencies = ["Red", "Green", "Blue", "Tartan"]
    // MARK: - Private properties
    @StateObject private var viewModel: CurrencyConvertViewModel
    @State private var selectedCurrency = "Red"
    @State private var value: Double?

    // MARK: - init
    public init (viewModel: CurrencyConvertViewModel = CurrencyConvertViewModel()) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        ScrollView {
            VStack {
                CurrencyTextField("Please enter the amount", value: self.$value, alwaysShowFractions: false, numberOfDecimalPlaces: 2, currencySymbol: "US$")
                           .multilineTextAlignment(TextAlignment.center)

                Picker("Please choose a currency", selection: $selectedCurrency) {
                    ForEach(currencies, id: \.self) {
                        Text($0)
                    }
                }

                ForEach (currencies, id: \.self) { currency in
                    CurrencyDetailView(detail: CurrencyDetail(name: currency,
                                                              title: "$ 101,814.02",
                                                              subtitle: "1 USD = 1.6 NZD"))
                }
            }
            .padding()
        }
        .task {
           await viewModel.fetchLatestCurrency()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        CurrencyConvertView()
    }
}
