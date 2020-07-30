//
//  Int+Date.swift
//  UltimateTravellerTool
//
//  Created by mickael ruzel on 30/07/2020.
//  Copyright © 2020 mickael ruzel. All rights reserved.
//

import Foundation

extension Int {
    var date: Date {
        let date = Date(timeIntervalSince1970: Double(self))
        return date
    }
}
