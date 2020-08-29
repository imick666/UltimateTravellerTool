//
//  ForecastWeatherResult.swift
//  UltimateTravellerTool
//
//  Created by mickael ruzel on 22/07/2020.
//  Copyright © 2020 mickael ruzel. All rights reserved.
//

import Foundation

struct WeatherResult: Decodable {
    var geolocalized: Bool? = false
    var name: String?
    var lat: Double
    var lon: Double
    var timezone_offset: Int
    var current: Current
    struct Current: Decodable {
        var dt: Int
        var temp: Double
        var weather: [Weather]
    }
    
    var hourly: [Hourly]
    struct Hourly: Decodable {
        var dt: Int
        var temp: Double
        var weather: [Weather]
        
    }
    
    var daily: [Daily]
    struct Daily: Decodable {
        var dt: Int
        var temp: Temp
        struct Temp: Decodable {
            var min: Double
            var max: Double
        }
        var weather: [Weather]
    }
    
    struct Weather: Decodable {
        var id: Int
        var description: String
        var icon: String
    }
}


