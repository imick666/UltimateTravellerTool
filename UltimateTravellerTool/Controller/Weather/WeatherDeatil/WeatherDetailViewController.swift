//
//  WeatherDetailViewController.swift
//  UltimateTravellerTool
//
//  Created by mickael ruzel on 22/07/2020.
//  Copyright © 2020 mickael ruzel. All rights reserved.
//

import UIKit

class WeatherDetailViewController: UIViewController {

    // MARK: - Outlet
    
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var weatherDescriptionLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var backGroundImageView: UIImageView!
    @IBOutlet weak var minTempLabel: UILabel!
    @IBOutlet weak var maxTempLabel: UILabel!
    @IBOutlet weak var todayLabel: UILabel!
    
    
    @IBOutlet weak var hourlyForecastCollectionView: UICollectionView!
    @IBOutlet weak var dailyForecastTableView: UITableView!
    
    // MARK: - Properties
    
    var dataSource: GlobalWeatherResult!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        dailyForecastTableView.delegate = self
        dailyForecastTableView.dataSource = self
        dailyForecastTableView.separatorStyle = .none
        dailyForecastTableView.allowsSelection = false
        
        hourlyForecastCollectionView.delegate = self
        hourlyForecastCollectionView.dataSource = self
        hourlyForecastCollectionView.allowsSelection = false
        
        setup()
        // Do any additional setup after loading the view.
    }
    
    // MARK: - Methodes

    private func setup() {
        cityNameLabel.text = dataSource.currentWeather.name
        weatherDescriptionLabel.text = dataSource.currentWeather.weather[0].description
        tempLabel.text = String(dataSource.currentWeather.main.temp) + " °C"
        minTempLabel.text = String(dataSource.currentWeather.main.temp_min)
        maxTempLabel.text = String(dataSource.currentWeather.main.temp_max)
        todayLabel.text = getDayName(from: dataSource.currentWeather.dt)
        
        let code = dataSource.currentWeather.weather[0].id
        if code >= 200 && code < 500 {
            backGroundImageView.image = UIImage(named: "thunderstorm")
        } else if code >= 500 && code < 800 {
            backGroundImageView.image = UIImage(named: "Rain")
        } else if code == 800 {
            backGroundImageView.image = UIImage(named: "Clear")
        } else if code > 800 {
            backGroundImageView.image = UIImage(named: "ClearCloud")
        }
        
        dataSource.forecastWeather.daily.remove(at: 0)
        
        dataSource.forecastWeather.hourly.removeSubrange(0..<24)
        
    }
    
    private func getDate(from timestamp: Int) -> Date {
        let date = Date(timeIntervalSince1970: Double(timestamp))
        return date
    }
    
    private func getDayName(from timestamp: Int) -> String {
        let date = getDate(from: timestamp)
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(secondsFromGMT: dataSource.currentWeather.timezone)
        formatter.dateFormat = "EEEE"
        
        return formatter.string(from: date).capitalized
    }
    
    private func getHour(from timestamp: Int) -> String {
        let date = getDate(from: timestamp)
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(secondsFromGMT: dataSource.currentWeather.timezone)
        formatter.dateFormat = "H"
        
        return formatter.string(from: date)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

// MARK: - TableView

extension WeatherDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.forecastWeather.daily.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let dailyCell = tableView.dequeueReusableCell(withIdentifier: "DailyTableViewCell") as? DailyTableViewCell else {
            return UITableViewCell()
        }
        
        dailyCell.weather = dataSource.forecastWeather.daily[indexPath.row]
        dailyCell.dayNameLabel.text = getDayName(from: dataSource.forecastWeather.daily[indexPath.row].dt)
        
        return dailyCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
}

// MARK: - CollectionView

extension WeatherDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.forecastWeather.hourly.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HourlyForecastCell", for: indexPath) as? HourlyForecastCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        let hourlyWeather = dataSource.forecastWeather.hourly[indexPath.row]
        
        cell.weather = hourlyWeather
        cell.hourLabel.text = getHour(from: hourlyWeather.dt) + "H"
        
        return cell
    }
}
