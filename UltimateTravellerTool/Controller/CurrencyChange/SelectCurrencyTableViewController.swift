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
        case iso, name
    }
    
    typealias currenciesIndex = (indexTitle: String, currencies: [(name:String, code: String)])
    
    // Outlets
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    // MARK: - Properties

    var passSelectedCurrencyDelegate: PassSelectedCurrency?
    var rates: CurrenciesResult?
    var buttonTag: Int?
    var sortBy: SortBy = .name {
        didSet {
            sortedSectionIndex()
        }
    }
    //create currencies list sorted in section by name
    var ratesList = [currenciesIndex]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    // MARK: - View life Cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        sortedSectionIndex()
    }

    // MARK: - Methodes
    
    //Sort index title
   private func sortedSectionIndex() {
       var currencies: [(name: String, code: String)] {
           switch sortBy {
           case .name:
               return sortByName()
           case .iso:
               return sortByIso()
           }
       }
       var result = [currenciesIndex]()
       
       for currency in currencies {
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
       ratesList = result.sorted { $0.indexTitle < $1.indexTitle }
   }
    
    private func sortByName() -> [(name: String, code: String)] {
        guard let list = rates?.rates else { return [(String, String)]() }
        var currencies = [(name: String, code: String)]()
        // Create tuple with Name and ISO Code
        for (key, _) in list {
            guard let name = Locale.current.localizedString(forCurrencyCode: key) else { continue }
            let currency = (name: name, code: key)
            currencies.append(currency)
        }
        
        //Sort all currencies by name
        return currencies.sorted { $0.name < $1.name }
    }
    
    private func sortByIso() -> [(name: String, code: String)] {
        guard let list = rates?.rates else { return [(String, String)]() }
        var currencies = [(name: String, code: String)]()
        //create tuple with Name and ISO Code
        for (key, _) in list {
            guard let name = Locale.current.localizedString(forCurrencyCode: key) else { continue }
            let currency = (name: name, code: key)
            currencies.append(currency)
        }
        
        //Sort all currencies by ISO
        return currencies.sorted { $0.code < $1.code }
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return ratesList.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let title = ratesList[section].indexTitle
        return title
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return ratesList[section].currencies.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        
        let currency = ratesList[indexPath.section].currencies[indexPath.row]
        let currencyName = currency.name
        let currencyCode = currency.code
        switch sortBy {
        case .name:
            cell.textLabel?.text = "\(currencyName) - \(currencyCode)"
        case .iso:
            cell.textLabel?.text = "\(currencyCode) - \(currencyName)"
        }
        

        // Configure the cell...

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedIso = ratesList[indexPath.section].currencies[indexPath.row].code
        guard let selectCurrency = rates?.rates[selectedIso] else { return }
        let dataToPass = (code: selectedIso, rate: selectCurrency)
        passSelectedCurrencyDelegate?.passCurrency(dataToPass, forButton: buttonTag)
        navigationController?.popViewController(animated: true)
    }

    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        var indexTitle = [String]()
        for title in ratesList {
            indexTitle.append(title.indexTitle)
        }
        return indexTitle
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

extension SelectCurrencyTableViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard !searchText.isEmpty else {
            sortedSectionIndex()
            return
        }
        
        var newIndex = [currenciesIndex]()
        
        for index in ratesList {
            var indexTitle = ""
            var currencies = [(name: String, code: String)]()
            for currency in index.currencies where currency.name.lowercased().hasPrefix(searchText.lowercased()) {
                indexTitle = index.indexTitle
                currencies.append(currency)
            }
            currencies.sort { $0.name < $1.name }
            let indexToAdd = (indexTitle, currencies)
            newIndex.append(indexToAdd)
        }
        
        ratesList = newIndex
    }
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        switch selectedScope {
        case 0:
            sortBy = .name
        case 1:
            sortBy = .iso
        default:
            return
        }
    }
}

extension SelectCurrencyTableViewController {
    
}
