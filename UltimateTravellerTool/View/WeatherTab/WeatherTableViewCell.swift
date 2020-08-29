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
    @IBOutlet weak var backGroundImageView: UIImageView!
    @IBOutlet weak var locationIcon: UIImageView!
    
    // MARK: - Properties
    
    let locationShortcutIcon = UIApplicationShortcutIcon(type: .location)
    
    var weather: WeatherResult! {
        didSet {
            locationIcon.isHidden = !(weather.geolocalized ?? false)
            cityNameLabel.text = weather.name
            weatherDetailLabel.text = weather.current.weather[0].description
            tempLabel.text = String(weather.current.temp.int) + "°C"
            iconImageView.getIcon(id: weather.current.weather[0].icon)
            setpBackGround()
        }
    }
    
    private func setpBackGround() {
        let code = weather.current.weather[0].id
        if code >= 200 && code < 500 {
            backGroundImageView.image = UIImage(named: "thunderstorm")
        } else if code >= 500 && code < 800 {
            backGroundImageView.image = UIImage(named: "Rain")
        } else if code == 800 {
            backGroundImageView.image = UIImage(named: "Clear")
        } else if code > 800 {
            backGroundImageView.image = UIImage(named: "ClearCloud")
        }
    }
}
