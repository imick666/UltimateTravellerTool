//
//  GlobalWeatherResult.swift
//  UltimateTravellerTool
//
//  Created by mickael ruzel on 23/07/2020.
//  Copyright © 2020 mickael ruzel. All rights reserved.
//

import Foundation

struct GlobalWeatherResult: Decodable {
    var currentWeather: CurrentWeatherResult
    var forecastWeather: ForecastWeatherResult
}
