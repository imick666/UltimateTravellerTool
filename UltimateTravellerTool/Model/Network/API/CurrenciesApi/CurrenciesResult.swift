//
//  CurrenciesResult.swift
//  UltimateTravellerTool
//
//  Created by mickael ruzel on 29/06/2020.
//  Copyright © 2020 mickael ruzel. All rights reserved.
//

import Foundation

struct CurrenciesResult: Decodable {
    let timestamp: Int
    let rates: [String:Double]
}
