//
//  GoogleTranslateResult.swift
//  UltimateTravellerTool
//
//  Created by mickael ruzel on 08/08/2020.
//  Copyright © 2020 mickael ruzel. All rights reserved.
//

import Foundation

struct GoogleTranslateResult: Decodable {
    var data: GoogleData
    struct GoogleData: Decodable {
        var translations: [Translations]
        struct Translations: Decodable {
            var translatedText: String
        }
    }
}
