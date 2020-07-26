//
//  WatherTableViewController.swift
//  UltimateTravellerTool
//
//  Created by mickael ruzel on 22/07/2020.
//  Copyright © 2020 mickael ruzel. All rights reserved.
//

import UIKit

class WeatherTableViewController: UITableViewController {
    
    // MARK: - Properties
    let weatherService = GlobalWeatherService()
    let dispatchGroup = DispatchGroup()
    
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
            getWeather(for: coord)
        }
        
        dispatchGroup.notify(queue: .main) {
            self.tableView.reloadData()
        }
    }

    // MARK: - Methodes
    
    private func getWeather(for param: [(String, Any)]) {
        dispatchGroup.enter()
        weatherService.getGlobalWeather(parameters: param) { (result) in
            switch result {
            case .success(let data):
                self.dataSource.append(data)
            case .failure(let error):
                print(error.description)
            }
            self.dispatchGroup.leave()
        }
    }
    
    private func udpateWeather(for weathers: [GlobalWeatherResult]) {
        
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return dataSource.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CurrentWeatherCell", for: indexPath) as? WeatherTableViewCell else { return UITableViewCell() }
        
        cell.weather = dataSource[indexPath.row].currentWeather

        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
