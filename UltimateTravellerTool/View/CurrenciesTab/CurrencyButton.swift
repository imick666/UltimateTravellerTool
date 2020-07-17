//
//  RoundedButton.swift
//  UltimateTravellerTool
//
//  Created by mickael ruzel on 04/07/2020.
//  Copyright © 2020 mickael ruzel. All rights reserved.
//

import UIKit

class CurrencyButton: UIButton {
    
    var currency: (code: String, rate: Double)? {
        didSet {
            let title = currency?.code ?? "Select a currency"
            self.setTitle(title, for: .normal)
        }
    }
    
    func setupButton() {
        self.layer.cornerRadius = self.bounds.height / 2
        titleLabel?.adjustsFontSizeToFitWidth = true
        titleLabel?.baselineAdjustment = .alignCenters
    }
}
