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
    
    var weather: ForecastWeatherResult.Daily! {
        didSet {
            dayNameLabel.text = ""
            minTempLabel.text = String(weather.temp.min) + " °C"
            maxTempLabel.text = String(weather.temp.max) + " °C"
            iconImageView.getIcon(id: weather.weather[0].icon)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
