//
//  CurrencyViewController+TextFieldDelegate.swift
//  UltimateTravellerTool
//
//  Created by mickael ruzel on 17/07/2020.
//  Copyright © 2020 mickael ruzel. All rights reserved.
//

import UIKit

extension CurrencyViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        guard let text = amountTextField[0].text, text.count <= 10 else {
            showAlert(title: "Amount Too Large", message: "The amount you try to convert is to large")
            amountTextField[0].deleteBackward()
            return
        }
        makeConvert(amount: text)
    }
}
