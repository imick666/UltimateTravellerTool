//
//  CurrenciesHandler.swift
//  UltimateTravellerTool
//
//  Created by mickael ruzel on 29/06/2020.
//  Copyright © 2020 mickael ruzel. All rights reserved.
//

import Foundation

class CurrenciesService {
    
    //MARK : - Properties
    private let formatter = NumberFormatter()
    private var httpClient: HTTPClient
    private let baseUrl = URL(string: "http://data.fixer.io/api/latest")
    
    //MARK : - Initalizer
    init(httpClient: HTTPClient = HTTPClient()) {
        self.httpClient = httpClient
    }
    
    //MARK : - Methodes
    func getCurrencies(callback: @escaping (Result<CurrenciesResult, NetworkError>) -> Void) {
        guard let url = baseUrl else { return }
        httpClient.request(baseUrl: url, parameters: [("access_key", ApiConfig.currecniesApiKey)]) { (result: Result<CurrenciesResult, NetworkError>) in
            callback(result)
        }
    }
    
    func convertCurrencies(from: Double, to: Double, amount: String) -> String? {
        let amountFormatted = amount.replacingOccurrences(of: " ", with: "")
        guard let amount = formatter.number(from: amountFormatted) as? Double else { return "" }
        let amountInEuro = amount / from
        let converted = amountInEuro * to
        formatter.numberStyle = .currency
        formatter.currencySymbol = ""
        formatter.groupingSeparator = ""
        let result = formatter.string(for: converted)
        return result
    }
}
