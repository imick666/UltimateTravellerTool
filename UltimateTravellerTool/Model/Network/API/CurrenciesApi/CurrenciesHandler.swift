//
//  CurrenciesHandler.swift
//  UltimateTravellerTool
//
//  Created by mickael ruzel on 29/06/2020.
//  Copyright © 2020 mickael ruzel. All rights reserved.
//

import Foundation

class CurrenciesHandler {
    
    //MARK: - PROPERTIES
    private var httpClient: HTTPClient
    private let baseUrl = URL(string: "http://data.fixer.io/api/latest")

    init(httpClient: HTTPClient = HTTPClient()) {
        self.httpClient = httpClient
    }
    
    //MARK: - METHODES
    func getCurrencies(callback: @escaping (Result<CurrenciesResult, NetworkError>) -> Void) {
        guard let baseUrl = baseUrl else { return }
        httpClient.request(baseUrl: baseUrl, parameters: [("access_key", ApiCinfig.CurrencieApiKey)]) { (result: Result<Data, NetworkError>) in
            guard case .success(let data) = result else {
                if case .failure(let error) = result {
                    callback(.failure(error))
                }
                return
            }
            do {
                let data = try JSONDecoder().decode(CurrenciesResult.self, from: data)
                callback(.success(data))
            } catch {
                callback(.failure(.dataUndecodable))
            }
        }
    }
}
