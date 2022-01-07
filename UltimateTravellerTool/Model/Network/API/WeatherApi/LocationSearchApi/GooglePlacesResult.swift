//
//  GooglePlacesResult.swift
//  UltimateTravellerTool
//
//  Created by mickael ruzel on 30/07/2020.
//  Copyright © 2020 mickael ruzel. All rights reserved.
//

import Foundation

struct GooglePlacesResult: Decodable {
    var predictions: [Predictions]
    struct Predictions: Decodable {
        var description: String
        var terms: [Terms]
        struct Terms: Decodable {
            var value: String
        }
    }
    
    
}
