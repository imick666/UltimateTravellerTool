//
//  GooglePlacesService.swift
//  UltimateTravellerTool
//
//  Created by mickael ruzel on 30/07/2020.
//  Copyright © 2020 mickael ruzel. All rights reserved.
//

import Foundation

final class GooglePlacesService {
    
    // MARK: - Properties
    
    private let baseUrl = "https://maps.googleapis.com/maps/api/place/autocomplete/json"
    private let client: HTTPClient
    
    // MARK: - Init
    
    init(client: HTTPClient = HTTPClient()) {
        self.client = client
    }
    
    // MARK: - Methodes
    
    /**
     Pick up a prediction of 5 citie's name from GooglePlaces
     - parameter q: the query to send for prediction
     - parameter callback: A closure containing the result or the error
     */
    func getCitiesName(q: String, callback: @escaping ((Result<GooglePlacesResult, NetworkError>) -> Void)) {
        guard let url = URL(string: baseUrl) else { return }
        
        var param = [(String, Any)]()
        param.append(("input", q))
        param.append(("types", "(cities)"))
        param.append(("key", ApiConfig.googlePlacesApiKey))
        
        client.requestJson(baseUrl: url, parameters: param) { (result: Result<GooglePlacesResult, NetworkError>) in
            callback(result)
        }
    }
    
}
