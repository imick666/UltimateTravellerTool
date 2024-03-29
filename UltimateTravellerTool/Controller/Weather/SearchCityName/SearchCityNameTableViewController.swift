//
//  SearchCityNameTableViewController.swift
//  UltimateTravellerTool
//
//  Created by mickael ruzel on 30/07/2020.
//  Copyright © 2020 mickael ruzel. All rights reserved.
//

import UIKit

class SearchCityNameTableViewController: UITableViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var dataSource = [GooglePlacesResult.Predictions]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    // MARK: - Properties
    
    let googlePlaces = GooglePlacesService()
    var selectCityDelegate: SelectCityDelegate?
    var alertController: UIAlertController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
    }

    // MARK: - Selectors
    
    @objc
    func tapGesture(_ sender: UITapGestureRecognizer) {
        searchBar.resignFirstResponder()
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        cell.textLabel?.text = dataSource[indexPath.row].description

        return cell
    }
    
    // MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cityName = dataSource[indexPath.row].terms[0].value
        selectCityDelegate?.cityDidSelect(city: cityName)
        alertController?.dismiss(animated: true, completion: nil)
    }
}

extension SearchCityNameTableViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        googlePlaces.getCitiesName(q: searchText) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .failure(let error):
                    self.showAlert(title: "ERROR", message: error.description)
                case .success(let data):
                    self.dataSource = data.predictions
                }
            }
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}
