//
//  HourlyForecastCollectionViewCell.swift
//  UltimateTravellerTool
//
//  Created by mickael ruzel on 27/07/2020.
//  Copyright © 2020 mickael ruzel. All rights reserved.
//

import UIKit

class HourlyForecastCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Outlet
    
    @IBOutlet weak var hourLabel: UILabel!
    @IBOutlet weak var iconImageView: WeatherIcon!
    @IBOutlet weak var tempLabel: UILabel!
    
    // MARK: - Properties
    
    var weather: WeatherResult.Hourly! {
        didSet {
            tempLabel.text = String(weather.temp.int) + "°C"
            iconImageView.getIcon(id: weather.weather[0].icon)
        }
    }
    
}
