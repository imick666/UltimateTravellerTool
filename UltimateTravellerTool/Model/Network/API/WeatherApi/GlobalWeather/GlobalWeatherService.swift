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
    
    init(currentWeather: CurrentWeatherService = CurrentWeatherService(), forecastWeather: ForecastWeatherService = ForecastWeatherService()) {
        self.currentWeather = currentWeather
        self.forecastWeather = forecastWeather
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
    
    func updateGlobalWeather(for weather: GlobalWeatherResult, callBack: @escaping ((Result<GlobalWeatherResult, NetworkError>) -> Void)) {
        let parameters = [("lon", weather.currentWeather.coord.lon), ("lat", weather.currentWeather.coord.lat)]
        getGlobalWeather(parameters: parameters) { (result) in
            callBack(result)
        }
    }
    
    func getIcon(id: String, callback: @escaping ((Result<Data, NetworkError>) -> Void)) {
        guard let url = URL(string: "http://openweathermap.org/img/wn/\(id)@2x.png") else {
            callback(.failure(.badUrl))
            return
        }
        
        let session = URLSession(configuration: .default)
        let request = session.dataTask(with: url) { (data, response, error) in
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                callback(.failure(.badResponse))
                return
            }
            guard error == nil else {
                callback(.failure(.noConnection))
                return
            }
            guard let data = data else {
                callback(.failure(.noData))
                return
            }
            callback(.success(data))
        }
        request.resume()
    }
}
