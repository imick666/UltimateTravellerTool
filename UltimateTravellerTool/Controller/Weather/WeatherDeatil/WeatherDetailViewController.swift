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
    @IBOutlet weak var todayLabel: UILabel!
    
    @IBOutlet weak var hourlyForecastCollectionView: UICollectionView!
    @IBOutlet weak var dailyForecastTableView: UITableView!
    
    // MARK: - Properties
    
    var dataSource: WeatherResult!
    
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
    }
    
    // MARK: - Methodes

    private func setup() {
        // Set label
        cityNameLabel.text = dataSource.name
        weatherDescriptionLabel.text = dataSource.current.weather[0].description
        tempLabel.text = String(dataSource.current.temp) + " °C"
        todayLabel.text = getDayName(from: dataSource.current.dt)
        
        // Set BackGround for each weather category
        let code = dataSource.current.weather[0].id
        if code >= 200 && code < 500 {
            backGroundImageView.image = UIImage(named: "thunderstorm")
        } else if code >= 500 && code < 800 {
            backGroundImageView.image = UIImage(named: "Rain")
        } else if code == 800 {
            backGroundImageView.image = UIImage(named: "Clear")
        } else if code > 800 {
            backGroundImageView.image = UIImage(named: "ClearCloud")
        }
        
        //sort arrays for remove unwanted informations
        dataSource.daily.remove(at: 0)
        dataSource.hourly.removeSubrange(0..<24)
        
    }
    
    // transform TimeStamp into Date
    private func getDate(from timestamp: Int) -> Date {
        let date = Date(timeIntervalSince1970: Double(timestamp))
        return date
    }
    
    // Transform Date into Day Name
    private func getDayName(from timestamp: Int) -> String {
        let date = getDate(from: timestamp)
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(secondsFromGMT: dataSource.timezone_offset)
        formatter.dateFormat = "EEEE"
        
        return formatter.string(from: date).capitalized
    }
    
    // Trnsform Date into Hour
    private func getHour(from timestamp: Int) -> String {
        let date = getDate(from: timestamp)
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(secondsFromGMT: dataSource.timezone_offset)
        formatter.dateFormat = "HH"
        
        return formatter.string(from: date)
    }
    
    // MARK: - Actions
    
    @IBAction func closeButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}

// MARK: - TableView

extension WeatherDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.daily.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let dailyCell = tableView.dequeueReusableCell(withIdentifier: "DailyTableViewCell") as? DailyTableViewCell else {
            return UITableViewCell()
        }
        
        dailyCell.weather = dataSource.daily[indexPath.row]
        dailyCell.dayNameLabel.text = getDayName(from: dataSource.daily[indexPath.row].dt)
        
        return dailyCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
}

// MARK: - CollectionView

extension WeatherDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.hourly.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HourlyForecastCell", for: indexPath) as? HourlyForecastCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        let hourlyWeather = dataSource.hourly[indexPath.row]
        
        cell.weather = hourlyWeather
        cell.hourLabel.text = getHour(from: hourlyWeather.dt) + "H"
        
        return cell
    }
}
