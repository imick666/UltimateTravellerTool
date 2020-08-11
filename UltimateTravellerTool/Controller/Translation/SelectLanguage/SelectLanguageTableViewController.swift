//
//  SelectLanguageTableViewController.swift
//  UltimateTravellerTool
//
//  Created by mickael ruzel on 08/08/2020.
//  Copyright © 2020 mickael ruzel. All rights reserved.
//

import UIKit

class SelectLanguageTableViewController: UITableViewController {

    // MARK: - Typealias
    
    typealias Languages = GoogleTranslateListResult.GoogleData.Languages
    typealias IndexedLanguages = (index: String, languages: [Languages])
    
    // MARK: - Properties
    
    let googleTranslateService = GoogleTranslateService()
    var delegate: passLanguageDelegate!
    
    var buttonId: Int!
    var dataSource: [IndexedLanguages]? {
        didSet {
            tableView.reloadData()
        }
    }
    
    // MARK: - View Cycle Life
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getLanguages()
        
        tableView.sectionIndexColor = .systemGray
    }

    // MARK: - Methodes
    
    private func getLanguages() {        
        googleTranslateService.getLinguageList { (result) in
            DispatchQueue.main.async {
                switch result {
                case .failure(let error):
                    self.showAlert(title: "Error", message: error.description)
                case .success(let data):
                    self.dataSource = self.sortLangueInSection(data.data.languages)
                }
            }
        }
    }
    
    private func sortLangueInSection(_ list: [Languages]) -> [IndexedLanguages] {
        var sorted = [IndexedLanguages]()
        
        for language in list {
            if sorted.contains(where: { $0.index == language.name.first?.uppercased()}) {
                guard let index = sorted.lastIndex(where: { $0.index == language.name.first?.uppercased() }) else { continue }
                sorted[index].languages.append(language)
            } else {
                guard let newIndexLette = language.name.first?.uppercased() else { continue }
                let newElement = (newIndexLette, [language])
                sorted.append(newElement)
            }
        }
        
        for (index, _) in sorted.enumerated() {
            sorted[index].languages.sort { $0.name < $1.name }
        }
        
        sorted.sort { $0.index < $1.index }
        
        return sorted
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return dataSource?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return dataSource?[section].index
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .systemBlue

        let title = dataSource?[section].index
        let titleLable = UILabel()
        titleLable.text = title
        titleLable.textColor = .white
        titleLable.font = .systemFont(ofSize: 17, weight: .semibold)
        titleLable.frame = CGRect(x: 20, y: 5, width: 100, height: 25)
        titleLable.textAlignment = .left

        view.addSubview(titleLable)

        return view
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return dataSource?[section].index == "" ? 0 : 35
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return dataSource?[section].languages.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
    
        cell.textLabel?.text = dataSource?[indexPath.section].languages[indexPath.row].name
        cell.textLabel?.font = .systemFont(ofSize: 17, weight: .semibold)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let language = dataSource?[indexPath.section].languages[indexPath.row] else { return }
        navigationController?.popViewController(animated: true)
        delegate.passLanguage(language, for: buttonId)
    }
    
    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        var indexTitle = [String]()
        
        if let data = dataSource {
            for index in data {
                indexTitle.append(index.index)
            }
        }
        
        return indexTitle
    }
}
