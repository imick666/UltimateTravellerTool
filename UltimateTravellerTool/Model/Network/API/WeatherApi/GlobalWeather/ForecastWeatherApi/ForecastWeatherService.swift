//
//  ForecastWeatherService.swift
//  UltimateTravellerTool
//
//  Created by mickael ruzel on 22/07/2020.
//  Copyright © 2020 mickael ruzel. All rights reserved.
//

import Foundation

final class ForecastWeatherService {
    
    private let baseUrl = "https://api.openweathermap.org/data/2.5/onecall"
    private let client: HTTPClient
    
    init(client: HTTPClient = HTTPClient()) {
        self.client = client
    }
    
    func getForecastWeather(parameters: [(String, Any)], callback: @escaping (Result<ForecastWeatherResult, NetworkError>) -> Void) {
        guard let url = URL(string: baseUrl) else {
            callback(.failure(.badUrl))
            return
        }
        
        var parameters = parameters
        parameters.append(("units", "metric"))
        parameters.append(("appid", ApiConfig.weatherApiKey))
        parameters.append(("exclude", "minutely,current"))
        
        client.request(baseUrl: url, parameters: parameters) { (result: Result<ForecastWeatherResult, NetworkError>) in
            callback(result)
        }
    }
    
}
