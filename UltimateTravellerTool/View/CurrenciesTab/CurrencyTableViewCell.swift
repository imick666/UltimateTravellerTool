//
//  CurrencyTableViewCell.swift
//  UltimateTravellerTool
//
//  Created by mickael ruzel on 14/07/2020.
//  Copyright © 2020 mickael ruzel. All rights reserved.
//

import UIKit

class CurrencyTableViewCell: UITableViewCell {

    @IBOutlet weak var currencyNameLable: UILabel!
    @IBOutlet weak var currencyCodeLabel: UILabel!
    
    var currencyName: String? {
        didSet {
            currencyNameLable.text = currencyName
        }
    }
    var currencyCode: String? {
        didSet {
            currencyCodeLabel.text = currencyCode
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
