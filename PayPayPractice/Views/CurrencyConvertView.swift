//
//  ContentView.swift
//  PayPayPractice
//
//  Created by Tony Mu on 23/08/22.
//

import SwiftUI

struct CurrencyConvertView: View {

    // MARK: - Private properties
    @StateObject private var viewModel: CurrencyConvertViewModel

    // MARK: - init
    public init (viewModel: CurrencyConvertViewModel = CurrencyConvertViewModel()) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        ScrollView {
            VStack {
                CurrencyTextField("Please enter the amount", value: $viewModel.amount, alwaysShowFractions: false, numberOfDecimalPlaces: 2)
                           .multilineTextAlignment(TextAlignment.center)

                Picker("Please choose a currency", selection: $viewModel.selectedCurrency) {
                    ForEach(viewModel.defaultCurrencyList, id: \.self) {
                        Text($0.code)
                    }
                }

                ForEach (viewModel.currencies, id: \.name) { currency in
                    RateDetailView(detail: currency)
                }
            }
            .onChange(of: viewModel.selectedCurrency, perform: { _ in
                viewModel.updateRatesDetail()
            })
            .onChange(of: viewModel.amount, perform: { _ in
                viewModel.updateRatesDetail()
            })
            .padding()
        }
        .onTapGesture {
            // Hide Keyboard
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder),
                                            to: nil,
                                            from: nil,
                                            for: nil)
        }
        .task {
           await viewModel.loadData()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        CurrencyConvertView()
    }
}
