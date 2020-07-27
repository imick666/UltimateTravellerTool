//
//  WeatherTableViewController+LocationManager.swift
//  UltimateTravellerTool
//
//  Created by mickael ruzel on 27/07/2020.
//  Copyright © 2020 mickael ruzel. All rights reserved.
//

import Foundation
import CoreLocation

extension WeatherTableViewController: CLLocationManagerDelegate {
    
    func locationSetUp() {
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        locationManager.stopUpdatingLocation()
        let parameters = [("lat", location.coordinate.latitude), ("lon", location.coordinate.longitude)]
        getWeather(for: parameters) { (result) in
            switch result {
            case .failure(let error):
                print(error.description)
            case .success(let data):
                if self.dataSource[0].currentWeather.coord.lat == data.currentWeather.coord.lat &&
                self.dataSource[0].currentWeather.coord.lon == data.currentWeather.coord.lon {
                    self.dataSource[0] = data
                } else {
                    self.dataSource.insert(data, at: 0)
                }
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error:" + error.localizedDescription)
    }
}
