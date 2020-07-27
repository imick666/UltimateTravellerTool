//
//  WatherTableViewController.swift
//  UltimateTravellerTool
//
//  Created by mickael ruzel on 22/07/2020.
//  Copyright © 2020 mickael ruzel. All rights reserved.
//

import UIKit
import CoreLocation

class WeatherTableViewController: UITableViewController {
    
    // MARK: - Properties
    let weatherService = GlobalWeatherService()
    let dispatchGroup = DispatchGroup()
    let locationManager = CLLocationManager()
    
    var dataSource = [GlobalWeatherResult]()
    
    let fakeCoord: [[(String, Any)]] = [
        [("lat", 39.90), ("lon", 116.39)],
        [("q", "montpellier")],
        [("q", "beziers")],
        [("lat", 46.19), ("lon", 6.23)]
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        fakeCoord.forEach { (coord) in
            getWeather(for: coord) { (result) in
                switch result {
                case .failure(let error):
                    print(error.description)
                case .success(let data):
                    self.dataSource.append(data)
                }
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            self.tableView.reloadData()
        }
        
        tableView.separatorStyle = .none
        
        locationSetUp()
    }

    // MARK: - Methodes
    
    func getWeather(for param: [(String, Any)], callback: @escaping ((Result<GlobalWeatherResult, NetworkError>) -> Void)) {
        dispatchGroup.enter()
        weatherService.getGlobalWeather(parameters: param) { (result) in
            callback(result)
            self.dispatchGroup.leave()
        }
    }
    
    private func udpateWeather(for weathers: [GlobalWeatherResult]) {
        
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CurrentWeatherCell", for: indexPath) as? WeatherTableViewCell else { return UITableViewCell() }
        
        cell.weather = dataSource[indexPath.row].currentWeather

        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "WeatherDetailSegue", sender: dataSource[indexPath.row])
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? WeatherDetailViewController {
            destination.dataSource = sender as? GlobalWeatherResult
        }
    }

}
