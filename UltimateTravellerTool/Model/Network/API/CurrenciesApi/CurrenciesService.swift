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
    
    /**
     Download the availible currencies list with there rates
     */
    func getCurrencies(callback: @escaping (Result<CurrenciesResult, NetworkError>) -> Void) {
        guard let url = baseUrl else { return }
        httpClient.requestJson(baseUrl: url, parameters: [("access_key", ApiConfig.currecniesApiKey)]) { (result: Result<CurrenciesResult, NetworkError>) in
            callback(result)
        }
    }
    
    /**
     Convert an amount from a currency to another
     - warning: The amout is convert in Euros before to before convert in the target currency
     - parameter from: The rate of source currency
     - parameter to: The rate of the target currency
     - parameter amount: The amount to convert
     */
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
