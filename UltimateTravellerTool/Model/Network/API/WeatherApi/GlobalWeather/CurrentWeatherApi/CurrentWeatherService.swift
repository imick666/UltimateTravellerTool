//
//  CurrentWeatherService.swift
//  UltimateTravellerTool
//
//  Created by mickael ruzel on 22/07/2020.
//  Copyright © 2020 mickael ruzel. All rights reserved.
//

import Foundation

final class CurrentWeatherService {
    
    private let baseURL = "https://api.openweathermap.org/data/2.5/weather"
    private let httpClient: HTTPClient
    
    init(client: HTTPClient = HTTPClient()) {
        self.httpClient = client
    }
    
    func getCurrentWeather(parameters: [(String, Any)], callback: @escaping ((Result<CurrentWeatherResult, NetworkError>) -> Void)) {
        guard let url = URL(string: baseURL) else {
            callback(.failure(.badUrl))
            return
        }

        var parameters = parameters
        parameters.append(("units", "metric"))
        parameters.append(("appid", ApiConfig.weatherApiKey))
        
        httpClient.requestJson(baseUrl: url, body: nil, parameters: parameters) { (result: Result<CurrentWeatherResult, NetworkError>) in
            callback(result)
        }
    }
}
