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
    @IBOutlet var selectCurrencyButton: [CurrencyButton]!
    @IBOutlet var amountTextField: [UITextField]!
    
    @IBOutlet weak var lastUpdateLabel: UILabel!
    
    // MARK: - Properties
    
    let currencyService = CurrenciesService()
    var currencyRate: CurrenciesResult? {
        didSet {
            let date = dateToDay(Date())
            let hour = dateToHour(Date())
            lastUpdateLabel.text = "Last update : \(date) at \(hour)"
        }
    }
    
    weak var PassSelectedCurrencyDelegate: PassSelectedCurrency?
    
    var switched = false {
        didSet {
            currencySwitched()
        }
    }
    
    // MARK: - View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setpUp()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = false
    }

    // MARK: - Methodes
    
    private func setpUp() {
        getCurrenciesRates()
        
        //Draw round button
        for button in selectCurrencyButton {
            button.setupButton()
        }
        
        //setup text field
//        amountTextField[0].delegate = self
        amountTextField[0].addTarget(self, action: #selector(textFieldTextDidChange(_:)), for: .editingChanged)
        
        // Create tap gesture for dismiss keyboard
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeayboard))
        view.addGestureRecognizer(tapGesture)
        
    }
    
    private func currencySwitched() {
        let currencyOne = selectCurrencyButton[0].currency
        selectCurrencyButton[0].currency = selectCurrencyButton[1].currency
        selectCurrencyButton[1].currency = currencyOne
        amountTextField[0].text = amountTextField[1].text
        makeConvert(amount: amountTextField[0].text ?? "")
    }
    
    func makeConvert(amount: String) {
        guard let rateOne = selectCurrencyButton[0].currency?.rate, let rateTwo = selectCurrencyButton[1].currency?.rate else {
            dismissKeayboard()
            showAlert(title: "No Currency Selected", message: "Please Select currencies before")
            for textField in amountTextField {
                textField.text = nil
            }
            return
        }
        
        let result = currencyService.convertCurrencies(from: rateOne, to: rateTwo, amount: amount)
        amountTextField[1].text = result
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
    
    // MARK: - Selector OBJC
    
    @objc
    private func dismissKeayboard() {
        amountTextField[0].resignFirstResponder()
    }
    
    @objc
    private func textFieldTextDidChange(_ sender: UITextField) {
        guard let text = amountTextField[0].text, text.count <= 10 else {
            showAlert(title: "Amount Too Large", message: "The amount you try to convert is to large")
            amountTextField[0].deleteBackward()
            return
        }
        makeConvert(amount: text)
    }
    
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
        dismissKeayboard()
        performSegue(withIdentifier: "SelectCurrency", sender: sender.tag)
    }
    
    @IBAction func reverseButtonPressed() {
        guard selectCurrencyButton[0].currency != nil, selectCurrencyButton[1].currency != nil else {
            showAlert(title: "No Currency Selected", message: "Please Select currencies before")
            return
        }
        switched.toggle()
    }
    
}

extension CurrencyViewController: PassSelectedCurrency {
    func passCurrency(_ currency: (code: String, rate: Double), forButton: Int?) {
        for button in selectCurrencyButton where button.tag == forButton {
            button.currency = currency
        }
        for textField in amountTextField {
            textField.text = nil
        }
    }
}
