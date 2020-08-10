//
//  SelectLanguageTableViewController.swift
//  UltimateTravellerTool
//
//  Created by mickael ruzel on 08/08/2020.
//  Copyright © 2020 mickael ruzel. All rights reserved.
//

import UIKit

class SelectLanguageTableViewController: UITableViewController {

    // MARK: - Properties
    
    let googleTranslateService = GoogleTranslateService()
    var delegate: passLanguageDelegate!
    
    var buttonId: Int!
    var dataSource: GoogleTranslateListResult.GoogleData? {
        didSet {
            tableView.reloadData()
        }
    }
    
    // MARK: - View Cycle Life
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getLanguages()
    }

    // MARK: - Methodes
    
    private func getLanguages() {        
        googleTranslateService.getLinguageList { (result) in
            DispatchQueue.main.async {
                switch result {
                case .failure(let error):
                    self.showAlert(title: "Error", message: error.description)
                case .success(var data):
                    data.data.languages.sort { $0.name < $1.name }
                    self.dataSource = data.data
                }
            }
        }
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return dataSource?.languages.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
    
        cell.textLabel?.text = dataSource?.languages[indexPath.row].name
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let language = dataSource?.languages[indexPath.row] else { return }
        dismiss(animated: true, completion: nil)
        delegate.passLanguage(language, for: buttonId)
    }
}
