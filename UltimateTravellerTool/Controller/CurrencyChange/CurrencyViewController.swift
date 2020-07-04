//
//  ViewController.swift
//  UltimateTravellerTool
//
//  Created by mickael ruzel on 29/06/2020.
//  Copyright © 2020 mickael ruzel. All rights reserved.
//

import UIKit

class CurrencyViewController: UIViewController {
    
    //MARK: - Outlet
    @IBOutlet weak var currencyOneView: SelectAndChangeView!
    @IBOutlet weak var currencyTwoView: SelectAndChangeView!
    
    
    //MARK: - Properties

    
    //MARK: - View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setpUp()
        if currencyOneView.isFrom {
            print("First Is From")
        } else if currencyTwoView.isFrom {
            print("Second Is From")
        }
    }

    //MARK: - Methodes
    
    private func setpUp() {
        //round button
        currencyOneView.currencyButton.roundButton()
        currencyTwoView.currencyButton.roundButton()
        
        //get currency rates
        currencyOneView.getCurrency()
        currencyTwoView.getCurrency()
        
        //link to controller
        currencyTwoView.controller = self
        currencyOneView.controller = self
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SelectCurrency" {
            guard let destination = segue.destination as? SelectCurrencyTableViewController else { return }
            destination.rates = sender as? CurrenciesResult
        }
    }
    
    //MARK: - Actions
    
}

