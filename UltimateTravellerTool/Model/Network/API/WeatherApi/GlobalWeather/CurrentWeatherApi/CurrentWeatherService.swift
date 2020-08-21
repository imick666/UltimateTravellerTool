//
//  CurrentWeatherService.swift
//  UltimateTravellerTool
//
//  Created by mickael ruzel on 22/07/2020.
//  Copyright © 2020 mickael ruzel. All rights reserved.
//

import Foundation

final class CurrentWeatherService {
    
    // MARK: - Properties
    
    private let baseURL = "https://api.openweathermap.org/data/2.5/weather"
    private let httpClient: HTTPClient
    private var localLanguage: String {
        return Locale.current.languageCode ?? "en"
    }
    
    // MARK: - Init
    
    init(client: HTTPClient = HTTPClient()) {
        self.httpClient = client
    }
    
    // MARK: - Methodes
    
    /**
     Get citie's coordinates with a city's name
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
    func getCoordForCity(parameters: [(String, Any)], callback: @escaping ((Result<CurrentWeatherResult, NetworkError>) -> Void)) {
        guard let url = URL(string: baseURL) else { return }

        var parameters = parameters
        parameters.append(("units", "metric"))
        parameters.append(("appid", ApiConfig.weatherApiKey))
        parameters.append(("lang", localLanguage))
        
        httpClient.requestJson(baseUrl: url, parameters: parameters) { (result: Result<CurrentWeatherResult, NetworkError>) in
            callback(result)
        }
    }
}
