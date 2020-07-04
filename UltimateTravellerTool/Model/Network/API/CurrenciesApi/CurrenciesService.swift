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
    private var httpClient: HTTPClient
    private let baseUrl = URL(string: "http://data.fixer.io/api/latest")
    
    private var currenciesRatesList: CurrenciesResult?
    
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
    
    func makeChangeCalcul(amount: Double, from: String, to: String, callback: ((Result<Double, Error>) -> Void)?) {
        guard let rates = currenciesRatesList?.rates else {
            getCurrencies { (result) in
                switch result {
                case .failure(let error):
                    callback?(.failure(error))
                case .success(let data):
                    DispatchQueue.main.async {
                        self.currenciesRatesList = data
                    }
                }
            }
            makeChangeCalcul(amount: amount, from: from, to: to, callback: nil)
            return
        }
        guard let fromRate = rates[from], let toRate = rates[to] else { return }
        let amountInEur = (amount / fromRate)
        let result = (amountInEur * toRate)
        
        let formatter = NumberFormatter()
        callback?(.success(result))
    }
}
