//
//  WatherTableViewController.swift
//  UltimateTravellerTool
//
//  Created by mickael ruzel on 22/07/2020.
//  Copyright © 2020 mickael ruzel. All rights reserved.
//

import UIKit
import CoreLocation

protocol SelectCityDelegate {
    func cityDidSelect(city: String)
}

class WeatherTableViewController: UITableViewController {

    // MARK: - Properties
    let weatherService = GlobalWeatherService()
    let dispatchGroup = DispatchGroup()
    let locationManager = CLLocationManager()
    var refreshcontrol = UIRefreshControl()
    
    // MARK: - DataSources
    
    var localWeatehr: WeatherResult?
    var dataSource = [WeatherResult]()
    var selectCityDelegate: SelectCityDelegate?
    
    // FakeData for test
    let fakeCoord: [[(String, Any)]] = [
        [("lat", 39.90), ("lon", 116.39)],
        [("q", "montpellier")],
        [("q", "beziers")],
        [("lat", 46.19), ("lon", 6.23)]
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Get porsition and add it to "localWeateher"
        locationSetUp()
        
        // Create FakeData
        fakeCoord.forEach { (coord) in
            getWeather(for: coord) { (result) in
                DispatchQueue.main.async {
                    switch result {
                    case .failure(let error):
                        self.showAlert(title: "Error", message: error.description)
                    case .success(let data):
                        self.dataSource.append(data)
                    }
                }
                
            }
        }
        
        // remove TableView seprator
        tableView.separatorStyle = .none
        
        // SetUp RefreshControl
        refreshcontrol.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
        tableView.addSubview(refreshcontrol)
    }

    // MARK: - Selector
    @objc
    private func refreshData(_ sender: UIRefreshControl) {
        updateWeather()
    }
    
    // MARK: - Methodes
    
    func getWeather(for param: [(String, Any)], callback: @escaping ((Result<WeatherResult, NetworkError>) -> Void)) {
        dispatchGroup.enter()
        weatherService.getGlobalWeather(parameters: param) { (result) in
            callback(result)
            self.dispatchGroup.leave()
        }
        
        dispatchGroup.notify(queue: .main) {
            self.refreshcontrol.endRefreshing()
            self.tableView.reloadData()
        }
    }
    
    private func updateWeather() {
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
        
        cell.weather = indexPath.row == 0 ? localWeatehr : dataSource[indexPath.row - 1]

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
        
        indexPath.row == 0 ? performSegue(withIdentifier: "WeatherDetailSegue", sender: localWeatehr) :  performSegue(withIdentifier: "WeatherDetailSegue", sender: dataSource[indexPath.row - 1])
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        localWeatehr != nil && indexPath.row == 0 ? false : true
        
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let index = localWeatehr != nil ? indexPath.row - 1 : indexPath.row

        if editingStyle == .delete {
            dataSource.remove(at: index)
            tableView.reloadData()
        }
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? WeatherDetailViewController {
            destination.dataSource = sender as? WeatherResult
        }
        if let destination = segue.destination as? SearchCityNameTableViewController {
            destination.delegate = self
        }
    }
    
    // MARK: Actions
    
    @IBAction func addCityButtonTapped(_ sender: Any) {
        performSegue(withIdentifier: "SearchCitySegue", sender: nil)
    }
}

extension WeatherTableViewController: SelectCityDelegate {
    func cityDidSelect(city: String) {
        getWeather(for: [("q", city)]) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .failure(let error):
                    self.showAlert(title: "Error", message: error.description)
                case .success(let data):
                    self.dataSource.append(data)
                }
            }
        }
    }
}
