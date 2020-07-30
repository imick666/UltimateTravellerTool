//
//  DailyTableViewCell.swift
//  UltimateTravellerTool
//
//  Created by mickael ruzel on 26/07/2020.
//  Copyright © 2020 mickael ruzel. All rights reserved.
//

import UIKit

class DailyTableViewCell: UITableViewCell {
    
    // MARK: - Outlet

    @IBOutlet weak var dayNameLabel: UILabel!
    @IBOutlet weak var iconImageView: WeatherIcon!
    @IBOutlet weak var minTempLabel: UILabel!
    @IBOutlet weak var maxTempLabel: UILabel!
    
    // MARK: - Properties
    
    var weather: WeatherResult.Daily! {
        didSet {
            dayNameLabel.text = ""
            minTempLabel.text = String(weather.temp.min.int) + " °C"
            maxTempLabel.text = String(weather.temp.max.int) + " °C"
            iconImageView.getIcon(id: weather.weather[0].icon)
        }
    }
}
