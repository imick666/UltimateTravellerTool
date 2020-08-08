//
//  WeatherIcon.swift
//  UltimateTravellerTool
//
//  Created by mickael ruzel on 22/07/2020.
//  Copyright © 2020 mickael ruzel. All rights reserved.
//

import UIKit

class WeatherIcon: UIImageView {
    
    let globalWeather = GlobalWeatherService()
    
    func getIcon(id: String) {
        globalWeather.getIcon(id: id) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .failure(let error):
                    print(error.description)
                case .success(let data):
                    let image = UIImage(data: data)
                    self.image = image
                }
            }
        }
    }
}
