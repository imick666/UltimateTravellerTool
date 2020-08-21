//
//  ForecastWeatherService.swift
//  UltimateTravellerTool
//
//  Created by mickael ruzel on 22/07/2020.
//  Copyright © 2020 mickael ruzel. All rights reserved.
//

import Foundation

final class WeatherService {
    
    // MARK: - Properties
    
    private let baseUrl = "https://api.openweathermap.org/data/2.5/onecall"
    private let client: HTTPClient
    private var localLanguage: String {
        return Locale.current.languageCode ?? "en"
    }
    
    // MARK: - Init
    
    init(client: HTTPClient = HTTPClient()) {
        self.client = client
    }
    
    // MARK: - Methodes
    
    /**
     Use for get current, hourly and daily citie's weather
     - the city location can be get with the city's name or the city's coordinate
     ```
     ex:
     parameters: [("q", "montpellier")]
     or
     parameter: [("lon", 1.52), ("lat", -52.512)]
     ```
     - parameter parameters: The city location
     - parameter callback: A closure containning the coordinate and the name for a city location
     */
    func getForecastWeather(parameters: [(String, Any)], callback: @escaping (Result<WeatherResult, NetworkError>) -> Void) {
        guard let url = URL(string: baseUrl) else { return }
        
        var parameters = parameters
        parameters.append(("units", "metric"))
        parameters.append(("exclude", "minutely"))
        parameters.append(("appid", ApiConfig.weatherApiKey))
        parameters.append(("lang", localLanguage))
        
        client.requestJson(baseUrl: url, parameters: parameters) { (result: Result<WeatherResult, NetworkError>) in
            callback(result)
        }
    }
    
}
