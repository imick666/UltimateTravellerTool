//
//  SelectCurrencyTableViewController.swift
//  UltimateTravellerTool
//
//  Created by mickael ruzel on 04/07/2020.
//  Copyright © 2020 mickael ruzel. All rights reserved.
//

import UIKit

class SelectCurrencyTableViewController: UITableViewController {
    
    enum SortBy {
        case iso
        case name
    }
    
    typealias CurrenciesIndex = (indexTitle: String, currencies: AllCurrencies)
    typealias AllCurrencies = [(name: String, code: String)]
    
    // Outlets

    @IBOutlet weak var searchBar: UISearchBar!
    
    // MARK: - Properties

    var passSelectedCurrencyDelegate: PassSelectedCurrency?
    var rates: CurrenciesResult!
    var buttonTag: Int?
    var sortBy: SortBy = .name {
        didSet {
            sortedSectionIndex { (result) in
                dataSource = result
            }
        }
    }
    
    //create currencies list sorted in section by name
    var dataSource = [CurrenciesIndex]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    // MARK: - View life Cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        
        //Set sortBy from scope selection
        switch searchBar.selectedScopeButtonIndex {
        case 0:
            sortBy = .name
        case 1:
            sortBy = .iso
        default:
            return
        }
        
        //Open table on "A" section with searchBar hide
        sortedSectionIndex { (result) in
            dataSource = result
        }
        tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: UITableView.ScrollPosition.top, animated: true)
        
        tableView.sectionIndexColor = .systemGray
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }

    // MARK: - Methodes
    
    //Sort index title
    func sortedSectionIndex(completion: (_ result: [CurrenciesIndex]) -> Void) {
        var result = [CurrenciesIndex]()
        var sortedCurrencies: AllCurrencies {
            switch sortBy {
            case .name:
                return sortByName()
            case .iso:
                return sortByIso()
            }
        }

        for currency in sortedCurrencies {
           var stringToCompare: String? {
               switch sortBy {
               case .name:
                   return currency.name.first?.uppercased()
               case .iso:
                   return currency.code.first?.uppercased()
               }
           }

           // Create tuple with IndexTitle and currencies Array
            if result.contains(where: {$0.indexTitle.uppercased() == stringToCompare}) {
                guard let index = result.lastIndex(where: { $0.indexTitle.uppercased() == stringToCompare}) else { continue }
               result[index].currencies.append(currency)
           } else {
               guard let indexTitle = stringToCompare else { continue }
               let elementToInsert = (indexTitle, [(currency)])
               result.append(elementToInsert)
           }
        }
        
       // Sort IndexTitle
        result.sort { $0.indexTitle < $1.indexTitle }
        
        completion(result)
    }
    
    private func sortByName() -> AllCurrencies {
        let list = rates.rates
        var currencies = [(name: String, code: String)]()
        // Create tuple with Name and ISO Code
        for (key, _) in list {
            guard let name = Locale.current.localizedString(forCurrencyCode: key) else { continue }
            let currency = (name: name.capitalized, code: key)
            currencies.append(currency)
        }
        
        //Sort all currencies by name
        return currencies.sorted { $0.name < $1.name }
    }
    
    private func sortByIso() -> AllCurrencies {
        let list = rates.rates
        var currencies = [(name: String, code: String)]()
        //create tuple with Name and ISO Code
        for (key, _) in list {
            guard let name = Locale.current.localizedString(forCurrencyCode: key) else { continue }
            let currency = (name: name.capitalized, code: key)
            currencies.append(currency)
        }
        
        //Sort all currencies by ISO
        return currencies.sorted { $0.code < $1.code }
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return dataSource.count
    }

    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .systemBlue

        let title = dataSource[section].indexTitle
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
        return dataSource[section].indexTitle == "" ? 0 : 35
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource[section].currencies.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let currencyCell = tableView.dequeueReusableCell(withIdentifier: "CurrencyCell") as? CurrencyTableViewCell else { return UITableViewCell() }

        let currency = dataSource[indexPath.section].currencies[indexPath.row]
        let currencyName = currency.name
        let currencyCode = currency.code
        
        switch sortBy {
        case .name:
            currencyCell.currencyName = currencyName
            currencyCell.currencyCode = currencyCode
        case .iso:
            currencyCell.currencyName = currencyCode
            currencyCell.currencyCode = currencyName
        }
        return currencyCell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedIso = dataSource[indexPath.section].currencies[indexPath.row].code
        guard let selectCurrency = rates?.rates[selectedIso] else { return }
        let dataToPass = (code: selectedIso, rate: selectCurrency)
        passSelectedCurrencyDelegate?.passCurrency(dataToPass, forButton: buttonTag)
        navigationController?.popViewController(animated: true)
    }

    // MARK: Section Index
    
    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        var indexTitle = [String]()
        for title in dataSource {
            indexTitle.append(title.indexTitle)
        }
        return indexTitle
    }
}
