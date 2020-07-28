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
    
    // MARK: - DataSources
    
    var localWeatehr: WeatherResult?
    var dataSource = [WeatherResult]()
    
    let fakeCoord: [[(String, Any)]] = [
        [("lat", 39.90), ("lon", 116.39)],
        [("q", "montpellier")],
        [("q", "beziers")],
        [("lat", 46.19), ("lon", 6.23)]
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationSetUp()
        
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
        
        tableView.separatorStyle = .none
    }

    // MARK: - Methodes
    
    func getWeather(for param: [(String, Any)], callback: @escaping ((Result<WeatherResult, NetworkError>) -> Void)) {
        dispatchGroup.enter()
        print("entered")
        weatherService.getGlobalWeather(parameters: param) { (result) in
            callback(result)
            self.dispatchGroup.leave()
            print("leaved")
        }
        
        dispatchGroup.notify(queue: .main) {
            self.tableView.reloadData()
            print("C'EST OK!!!!!!!!!!")
        }
    }
    
    private func updateWeather() {
        print("refresh in progress")
        // update local Weather
        locationSetUp()
        
        // update other Weather
        for (index, weather) in dataSource.enumerated() {
            let coord = [("lat", weather.lat), ("lon", weather.lon)]
            getWeather(for: coord) { (result) in
                switch result {
                case .failure(_):
                    return
                case .success(let data):
                    self.dataSource[index] = data
                }
            }
        }
        
        tableView.endUpdates()
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard localWeatehr != nil else { return dataSource.count }
        return dataSource.count + 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CurrentWeatherCell", for: indexPath) as? WeatherTableViewCell else { return UITableViewCell() }
        
        guard localWeatehr != nil else {
            cell.weather = dataSource[indexPath.row]
            return cell
        }
        
        if indexPath.row == 0 {
            cell.weather = localWeatehr
        } else {
            cell.weather = dataSource[indexPath.row - 1]
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard localWeatehr != nil else {
            performSegue(withIdentifier: "WeatherDetailSegue", sender: dataSource[indexPath.row])
            return
        }
        
        if indexPath.row == 0 {
            performSegue(withIdentifier: "WeatherDetailSegue", sender: localWeatehr)
        } else {
            performSegue(withIdentifier: "WeatherDetailSegue", sender: dataSource[indexPath.row - 1])
        }
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? WeatherDetailViewController {
            destination.dataSource = sender as? WeatherResult
        }
    }

}
