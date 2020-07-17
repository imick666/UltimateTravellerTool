//
//  RoundedButton.swift
//  UltimateTravellerTool
//
//  Created by mickael ruzel on 04/07/2020.
//  Copyright © 2020 mickael ruzel. All rights reserved.
//

import UIKit

class RoundedButton: UIButton {
    
    func roundButton() {
        self.layer.cornerRadius = self.bounds.height / 2
    }
}
