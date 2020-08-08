//
//  GooglePlacesService.swift
//  UltimateTravellerTool
//
//  Created by mickael ruzel on 30/07/2020.
//  Copyright © 2020 mickael ruzel. All rights reserved.
//

import Foundation

final class GooglePlacesService {
    
    private let baseUrl = "https://maps.googleapis.com/maps/api/place/autocomplete/json"
    private let client: HTTPClient
    
    init(client: HTTPClient = HTTPClient()) {
        self.client = client
    }
    
    func getCitiesName(q: String, callback: @escaping ((Result<GooglePlacesResult, NetworkError>) -> Void)) {
        guard let url = URL(string: baseUrl) else {
            callback(.failure(.badUrl))
            return
        }
        
        var param = [(String, Any)]()
        param.append(("input", q))
        param.append(("types", "(cities)"))
        param.append(("key", ApiConfig.googlePlacesApiKey))
        
        client.requestJson(baseUrl: url, body: nil, parameters: param) { (result: Result<GooglePlacesResult, NetworkError>) in
            callback(result)
        }
    }
    
}
