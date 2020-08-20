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
        getWeatherfor(city: parameters) { (result) in
            switch result {
            case .failure(let error):
                print(error.description)
            case .success(let data):
                self.localWeatehr = data
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error:" + error.localizedDescription)
    }
}
