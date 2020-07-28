//
//  CurrentWeatherResult.swift
//  UltimateTravellerTool
//
//  Created by mickael ruzel on 22/07/2020.
//  Copyright © 2020 mickael ruzel. All rights reserved.
//

import Foundation

struct CurrentWeatherResult: Decodable {
    var name: String
    var coord: Coord
    struct Coord: Decodable {
        var lon: Double
        var lat: Double
    }
}
