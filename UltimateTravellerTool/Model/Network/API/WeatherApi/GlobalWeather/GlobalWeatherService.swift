//
//  GlobalWeatherService.swift
//  UltimateTravellerTool
//
//  Created by mickael ruzel on 23/07/2020.
//  Copyright © 2020 mickael ruzel. All rights reserved.
//

import Foundation

final class GlobalWeatherService {
    
    private let currentWeather: CurrentWeatherService
    private let forecastWeather: ForecastWeatherService
    private let client: HTTPClient
    
    init(currentWeather: CurrentWeatherService = CurrentWeatherService(), forecastWeather: ForecastWeatherService = ForecastWeatherService(), client: HTTPClient = HTTPClient()) {
        self.currentWeather = currentWeather
        self.forecastWeather = forecastWeather
        self.client = client
    }
    
    func getGlobalWeather(parameters: [(String, Any)], callback: @escaping ((Result<GlobalWeatherResult, NetworkError>) -> Void)) {
        // PickUp Current Weather
        currentWeather.getCurrentWeather(parameters: parameters) { (currentResult) in
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
                    case .success(let forecastData):
                        //Create Global Weather
                        let globalWeather = GlobalWeatherResult(currentWeather: currentData, forecastWeather: forecastData)
                        callback(.success(globalWeather))
                    }
                }
            }
        }
    }
    
    func getIcon(id: String, callback: @escaping ((Result<Data, NetworkError>) -> Void)) {
        guard let url = URL(string: "http://openweathermap.org/img/wn/\(id)@2x.png") else {
            callback(.failure(.badUrl))
            return
        }
        
        client.requestData(baseUrl: url, parameters: nil) { (result) in
            callback(result)
        }
    }
}
