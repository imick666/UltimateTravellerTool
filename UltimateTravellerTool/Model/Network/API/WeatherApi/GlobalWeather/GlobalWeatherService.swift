//
//  GlobalWeatherService.swift
//  UltimateTravellerTool
//
//  Created by mickael ruzel on 23/07/2020.
//  Copyright © 2020 mickael ruzel. All rights reserved.
//

import Foundation

final class GlobalWeatherService {
    
    // MARK: - Properties
    
    private let currentWeather: CurrentWeatherService
    private let forecastWeather: WeatherService
    private let client: HTTPClient
    
    // MARK: - Init
    
    init(currentWeather: CurrentWeatherService = CurrentWeatherService(), forecastWeather: WeatherService = WeatherService(), client: HTTPClient = HTTPClient()) {
        self.currentWeather = currentWeather
        self.forecastWeather = forecastWeather
        self.client = client
    }
    
    // MARK: Methodes
    
    /**
     Get the weather for a location
     - the city location can be get with the city name or the corrdinate
     ```
     ex:
     [("q", "paris")]
     or
     [("lat", 1.52), ("lon", -53.618)]
     ```
     - parameter parameters: A tuple containing the city location
     - parameter callback: A closure containing the city's weather or the error
     
     */
    func getGlobalWeather(parameters: [(String, Any)], callback: @escaping ((Result<WeatherResult, NetworkError>) -> Void)) {
        // PickUp Current Weather
        currentWeather.getCoordForCity(parameters: parameters) { (currentResult) in
            switch currentResult {
            case .failure(let error):
                callback(.failure(error))
            case .success(let currentData):
                let param = [("lat", currentData.coord.lat), ("lon", currentData.coord.lon)]
                
                //PickUp Forecast Weather
                self.forecastWeather.getForecastWeather(parameters: param) { (forecastResult) in
                    switch forecastResult {
                    case .failure(let error):
                        callback(.failure(error))
                    case .success(var weatherData):
                        weatherData.name = currentData.name
                        callback(.success(weatherData))
                    }
                }
            }
        }
    }
    
    /**
     Get the icon from a code given by weather prediction
     - warning: the data is an image
     - parameter id: the ID given by the prediction
     - parameter callback: A closure containing the image Data or the error
     */
    
    func getIcon(id: String, callback: @escaping ((Result<Data, NetworkError>) -> Void)) {
        guard let url = URL(string: "http://openweathermap.org/img/wn/\(id)@2x.png") else { return }
        
        client.requestData(baseUrl: url, parameters: nil) { (result) in
            callback(result)
        }
    }
}
