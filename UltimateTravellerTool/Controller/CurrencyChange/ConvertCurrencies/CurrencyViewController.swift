//
//  ViewController.swift
//  UltimateTravellerTool
//
//  Created by mickael ruzel on 29/06/2020.
//  Copyright © 2020 mickael ruzel. All rights reserved.
//

import UIKit

protocol PassSelectedCurrency: class {
    func passCurrency(_ currency: (code: String, rate: Double), forButton: Int?)
}

class CurrencyViewController: UIViewController {
    
    // MARK: - Outlet
    @IBOutlet var selectCurrencyButton: [RoundedButton]!
    @IBOutlet var amountTextField: [UITextField]!
    
    @IBOutlet weak var lastUpdateLabel: UILabel!
    
    // MARK: - Properties
    
    let currencyService = CurrenciesService()
    var currencyRate: CurrenciesResult? {
        didSet {
            let date = timeStampToDay(currencyRate?.timestamp ?? 0)
            let hour = timeStampToHour(currencyRate?.timestamp ?? 0)
            lastUpdateLabel.text = "Last update : \(date) at \(hour)"
        }
    }
    
    weak var PassSelectedCurrencyDelegate: PassSelectedCurrency?
    
    var switched = false {
        didSet {
            currencySwitched()
        }
    }
    
    var currencyOne: (code: String, rate: Double)? {
        didSet {
            currencySwitched()
        }
    }
    
    var currencyTwo: (code: String, rate: Double)? {
        didSet {
            currencySwitched()
        }
    }
    
    // MARK: - View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setpUp()
    }

    // MARK: - Methodes
    
    private func setpUp() {
        getCurrenciesRates()
        
        //Draw round button
        for button in selectCurrencyButton {
            button.roundButton()
            button.titleLabel?.adjustsFontSizeToFitWidth = true
            button.titleLabel?.baselineAdjustment = .alignCenters
        }
        
        //setup text field
        currencySwitched()
        amountTextField[1].isEnabled = false
        amountTextField[0].delegate = self
    }
    
    private func currencySwitched() {
        switch switched {
        case true:
            selectCurrencyButton[0].setTitle(currencyTwo?.code ?? "Select Currency", for: .normal)
            selectCurrencyButton[1].setTitle(currencyOne?.code ?? "Select Currency", for: .normal)
        case false:
            selectCurrencyButton[0].setTitle(currencyOne?.code ?? "Select Currency", for: .normal)
            selectCurrencyButton[1].setTitle(currencyTwo?.code ?? "Select Currency", for: .normal)
        }
        amountTextField[0].text = amountTextField[1].text
    }
    
    func makeConvert(amount: String) {
        guard let rateOne = currencyOne?.rate, let rateTwo = currencyTwo?.rate else {
            showAlert(title: "No Currency Selected", message: "Please Select currencies before")
            for textField in amountTextField {
                textField.text = nil
            }
            return
        }
        
        if !switched {
            let result = currencyService.convertCurrencies(from: rateOne, to: rateTwo, amount: amount)
            amountTextField[1].text = result
        } else {
            let result = currencyService.convertCurrencies(from: rateTwo, to: rateOne, amount: amount)
            amountTextField[1].text = result
        }
    }
    
    private func getCurrenciesRates() {
        currencyService.getCurrencies { [unowned self] result in
            DispatchQueue.main.async {
                switch result {
                case .failure(let error):
                    self.showAlert(title: "Error", message: error.description)
                case .success(let data):
                    self.currencyRate = data
                }
            }
        }
    }
    
    // MARK: - Animations
    
    // MARK: - Segues
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SelectCurrency" {
            guard let destination = segue.destination as? SelectCurrencyTableViewController else { return }
            destination.rates = currencyRate
            destination.buttonTag = sender as? Int
            destination.passSelectedCurrencyDelegate = self
        }
    }
    
    //MARK: - Actions
    
    @IBAction func selectCurrencyButtonTaped(_ sender: UIButton) {
        guard currencyRate != nil else {
            showAlert(title: "Error", message: "A probleme is append, please retry later")
            return
        }
        performSegue(withIdentifier: "SelectCurrency", sender: sender.tag)
    }
    
    @IBAction func reverseButtonPressed() {
        switched.toggle()
    }
    
}



extension CurrencyViewController: PassSelectedCurrency {
    func passCurrency(_ currency: (code: String, rate: Double), forButton: Int?) {
        switch forButton {
        case 0:
            currencyOne = currency
        case 1:
            currencyTwo = currency
        default:
            return
        }
    }
}

