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
    
    typealias Language = GoogleTranslateListResult.GoogleData.Languages
    typealias IndexedLanguages = (index: String, languages: [Language])
    
    // MARK: - Properties
    
    let googleTranslateService = GoogleTranslateService()
    weak var delegate: PassLanguageDelegate!
    
    var dataSource = [IndexedLanguages]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    // MARK: - View Cycle Life
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.sectionIndexColor = .systemGray
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }

    // MARK: - Methodes
    
    /**
     Sort the languages list in section
     - parameter list: An array of languages to sort
     - warning: This function create an array of tuple (indexTitle: String, languages: [Language]), and add it to dataSource property
     */
    func sortLangueInSection(_ list: [Language]) {
        var sorted = [IndexedLanguages]()
        
        for language in list {
            if sorted.contains(where: { $0.index == language.name?.first?.uppercased()}) {
                guard let index = sorted.lastIndex(where: { $0.index == language.name?.first?.uppercased() }) else { continue }
                sorted[index].languages.append(language)
            } else {
                guard let newIndexLette = language.name?.first?.uppercased() else { continue }
                let newElement = (newIndexLette, [language])
                sorted.append(newElement)
            }
        }
        
        for (index, _) in sorted.enumerated() {
            sorted[index].languages.sort { $0.name ?? "NC" < $1.name ?? "NC" }
        }
        
        sorted.sort { $0.index < $1.index }
        
        dataSource = sorted
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return dataSource.count
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return dataSource[section].index
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .systemBlue

        let title = dataSource[section].index
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
        return dataSource[section].index == "" ? 0 : 35
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource[section].languages.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
    
        cell.textLabel?.text = dataSource[indexPath.section].languages[indexPath.row].name
        cell.textLabel?.font = .systemFont(ofSize: 17, weight: .semibold)
        
        return cell
    }
    
    // MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let language = dataSource[indexPath.section].languages[indexPath.row]
        navigationController?.popViewController(animated: true)
        delegate.passLanguage(language)
    }
    
    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        var indexTitle = [String]()
        
        for index in dataSource {
            indexTitle.append(index.index)
        }
        
        return indexTitle
    }
}
