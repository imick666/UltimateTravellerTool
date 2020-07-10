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
    
    //MARK: - Outlet
    @IBOutlet weak var currencyOneView: UIView!
    @IBOutlet weak var currencyTwoView: UIView!
    
    @IBOutlet weak var currencyOneStakView: UIStackView!
    @IBOutlet weak var currencyTwoStackView: UIStackView!
    
    
    @IBOutlet var selectCurrencyButton: [RoundedButton]!
    @IBOutlet var amountTextField: [UITextField]!
    
    //MARK: - Properties

    let currencyService = CurrenciesService()
    var currencyRate: CurrenciesResult?
    weak var PassSelectedCurrencyDelegate: PassSelectedCurrency?
    let alertController = Alert()
    
    var switched = false {
        didSet {
            setupTextField()
        }
    }
    var currencyOne: (code: String, rate: Double)? {
        didSet {
            setupButton()
        }
    }
    var currencyTwo: (code: String, rate: Double)? {
        didSet {
            setupButton()
        }
    }
    //MARK: - View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setpUp()
    }

    //MARK: - Methodes
    
    private func setpUp() {
        // Get currencies rates
        getCurrenciesRates()
        
        //Draw round button
        for button in selectCurrencyButton {
            button.roundButton()
            button.titleLabel?.adjustsFontSizeToFitWidth = true
            button.titleLabel?.baselineAdjustment = .alignCenters
        }
        
        setupButton()
        
        //setup text field
        setupTextField()
    }
    
    private func setupButton() {
        selectCurrencyButton[0].setTitle(currencyOne?.code ?? "Select Currency", for: .normal)
        selectCurrencyButton[1].setTitle(currencyTwo?.code ?? "Select Currency", for: .normal)
    }
    
    private func setupTextField() {
        switch switched {
        case false :
            amountTextField[0].isEnabled = true
            amountTextField[1].isEnabled = false
            amountTextField[0].delegate = self
        case true :
            amountTextField[0].isEnabled = false
            amountTextField[1].isEnabled = true
            amountTextField[1].delegate = self
        }
    }
    
    private func getCurrenciesRates() {
        currencyService.getCurrencies { (result) in
            DispatchQueue.main.async {
                switch result {
                case .failure(let error):
                    self.alertController.showAlert(title: "Error", message: error.description, controller: self)
                case .success(let data):
                    self.currencyRate = data
                }
            }
            
        }
    }
    
    // MARK: - Animations

    
    private func currencyTwoAnimation(x: CGFloat, y: CGFloat) {
        UIView.animate(withDuration: 0.5, animations: {
            self.currencyTwoView.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
        }) { (_) in
            UIView.animate(withDuration: 0.5, animations: {
                self.currencyTwoView.transform = CGAffineTransform(translationX: x, y: y)
            }) { (_) in
                
            }
            
        }
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
        performSegue(withIdentifier: "SelectCurrency", sender: sender.tag)
    }
    @IBAction func reverseButtonPressed() {
        switched = !switched
    }
    
}

extension CurrencyViewController: UITextFieldDelegate {
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        guard let rateOne = currencyOne?.rate else { return }
        guard let rateTwo = currencyTwo?.rate else { return }
        guard let text = textField.text else { return }
        
        if !switched {
            let result = currencyService.convertCurrencies(from: rateOne, to: rateTwo, amount: text)
            amountTextField[1].text = result
        } else {
            let result = currencyService.convertCurrencies(from: rateTwo, to: rateOne, amount: text)
            amountTextField[0].text = result
        }
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

