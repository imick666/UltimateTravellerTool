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
            let title = currency?.code
            self.setTitle(title, for: .normal)
        }
    }
    
    func setupButton() {
        self.layer.cornerRadius = self.bounds.height / 2
        titleLabel?.adjustsFontSizeToFitWidth = true
        titleLabel?.baselineAdjustment = .alignCenters
        self.layer.shadowOffset = CGSize(width: 0, height: 5)
        self.layer.shadowRadius = 8
        self.layer.shadowOpacity = 0.3
    }
}
