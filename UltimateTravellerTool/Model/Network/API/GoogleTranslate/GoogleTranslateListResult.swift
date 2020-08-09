//
//  GoogleTranslateListResult.swift
//  UltimateTravellerTool
//
//  Created by mickael ruzel on 08/08/2020.
//  Copyright © 2020 mickael ruzel. All rights reserved.
//

import Foundation

struct GoogleTranslateListResult: Decodable {
    var data: GoogleData
    struct GoogleData: Decodable {
        var languages: [Languages]
        struct Languages: Decodable {
            var language: String
            var name: String
        }
    }
}
