//
//  ForecastWeatherResult.swift
//  UltimateTravellerTool
//
//  Created by mickael ruzel on 22/07/2020.
//  Copyright © 2020 mickael ruzel. All rights reserved.
//

import Foundation

struct ForecastWeatherResult: Decodable {
    var hourly: [Hourly]
    struct Hourly: Decodable {
        var dt: Int
        var temp: Double
        var weather: [Weather]
        struct Weather: Decodable {
            var description: String
            var icon: String
        }
    }
    
    var daily: [Daily]
    struct Daily: Decodable {
        var dt: Int
        var sunrise: Int
        var sunset: Int
        var temp: Temp
        struct Temp: Decodable {
            var min: Double
            var max: Double
        }
        var weather: [Weather]
        struct Weather: Decodable {
            var description: String
            var icon: String
        }
    }
}


