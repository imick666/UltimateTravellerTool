//
//  CurrentWeatherResult.swift
//  UltimateTravellerTool
//
//  Created by mickael ruzel on 22/07/2020.
//  Copyright © 2020 mickael ruzel. All rights reserved.
//

import Foundation

struct CurrentWeatherResult: Decodable {
    var dt: Int
    var timezone: Int
    var name: String
    var coord: Coord
    struct Coord: Decodable {
        var lon: Double
        var lat: Double
    }
    var weather: [Weather]
    struct Weather: Decodable {
        var id: Int
        var description: String
        var icon: String
    }

    var main: Main
    struct Main: Decodable {
        var temp: Double
        var temp_min: Double
        var temp_max: Double
    }
}
