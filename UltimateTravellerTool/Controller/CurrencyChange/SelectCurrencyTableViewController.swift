//
//  SelectCurrencyTableViewController.swift
//  UltimateTravellerTool
//
//  Created by mickael ruzel on 04/07/2020.
//  Copyright © 2020 mickael ruzel. All rights reserved.
//

import UIKit


class SelectCurrencyTableViewController: UITableViewController {

    var passSelectedCurrencyDelegate: PassSelectedCurrency?
    var rates: CurrenciesResult?
    var buttonTag: Int?
    
    var ratesList: [(name:String, code: String)] {
        guard let list = rates?.rates else { return [(String, String)]() }
        var tuple = [(name: String, code: String)]()
        for (key, _) in list {
            guard let name = Locale.current.localizedString(forCurrencyCode: key) else { continue }
            let currency = (name: name, code: key)
            tuple.append(currency)
        }
        return tuple.sorted { $0.name < $1.name }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return ratesList.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        
        let currencyCode = ratesList[indexPath.row].code
        let currencyName = ratesList[indexPath.row].name
        cell.textLabel?.text = "\(currencyName) - \(currencyCode)"

        // Configure the cell...

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedIso = ratesList[indexPath.row].code
        guard let selectCurrency = rates?.rates[selectedIso] else { return }
        let dataToPass = (code: selectedIso, rate: selectCurrency)
        passSelectedCurrencyDelegate?.passCurrency(dataToPass, forButton: buttonTag)
        navigationController?.popViewController(animated: true)
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
