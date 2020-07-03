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
}
