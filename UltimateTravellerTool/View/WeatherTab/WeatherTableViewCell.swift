//
//  WeatherTableViewCell.swift
//  UltimateTravellerTool
//
//  Created by mickael ruzel on 22/07/2020.
//  Copyright © 2020 mickael ruzel. All rights reserved.
//

import UIKit

class WeatherTableViewCell: UITableViewCell {

    // MARK: - Outlets

    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var weatherDetailLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var iconImageView: WeatherIcon!
    
    // MARK: - Properties
    
    var weather: CurrentWeatherResult! {
        didSet {
            cityNameLabel.text = weather.name
            weatherDetailLabel.text = weather.weather[0].description
            tempLabel.text = String(weather.main.temp)
        }
    }
}
