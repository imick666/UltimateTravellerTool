//
//  FileSelectCurrencyTableViewController+UISearchBar.swift
//  UltimateTravellerTool
//
//  Created by mickael ruzel on 17/07/2020.
//  Copyright © 2020 mickael ruzel. All rights reserved.
//

import UIKit

extension SelectCurrencyTableViewController: UISearchBarDelegate {

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard !searchText.isEmpty else {
            sortedSectionIndex { (result) in
                dataSource = result
            }
            return
        }

        var newIndex = [CurrenciesIndex]()

        sortedSectionIndex { (result) in
            for index in result {
                var indexTitle: String?
                var currencies = [(name: String, code: String)]()
                for currency in index.currencies where currency.name.lowercased().contains(searchText.lowercased()) {
                    indexTitle = index.indexTitle
                    currencies.append(currency)
                }
                
                currencies.sort { $0.name < $1.name }
                let indexToAdd = (indexTitle, currencies)
                newIndex.append(indexToAdd)
            }
        }
        dataSource = newIndex
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
        searchBar.text = nil
        searchBar.resignFirstResponder()
        tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: UITableView.ScrollPosition.top, animated: true)

    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}
