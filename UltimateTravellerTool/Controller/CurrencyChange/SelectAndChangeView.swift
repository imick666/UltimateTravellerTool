//
//  SelectAndChangeViewController.swift
//  UltimateTravellerTool
//
//  Created by mickael ruzel on 04/07/2020.
//  Copyright © 2020 mickael ruzel. All rights reserved.
//

import UIKit

class SelectAndChangeView: UIView {
    
    //MARK: - Outlet
    
    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var currencyButton: RoundedButton!
    
    //MARK: - Properties
    var controller: CurrencyViewController?
    let currencyService = CurrenciesService()
    var currencyRates: CurrenciesResult?
    var isFrom: Bool {
        let halfScreenHieght = UIScreen.main.bounds.height / 2
        let response = self.layer.bounds.maxY <= halfScreenHieght
        return response
    }
    
    //MARK: -Methodes
    
    func getCurrency() {
        currencyService.getCurrencies { (result) in
            switch result {
            case .failure(_):
                return
            case .success(let data):
                DispatchQueue.main.async {
                    self.currencyRates = data
                }
            }
        }
    }
    
    
    //MARK: - Actions
    
    @IBAction func amountDidChange(sender: Any) {
        
    }
    
    @IBAction func currencyButtonDidTap() {
        print("position From : \(isFrom)")
//        controller?.performSegue(withIdentifier: "SelectCurrency", sender: currencyRates)
    }
    
    
}
