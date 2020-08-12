//
//  GoogleTranslateDetectResult.swift
//  UltimateTravellerTool
//
//  Created by mickael ruzel on 12/08/2020.
//  Copyright © 2020 mickael ruzel. All rights reserved.
//

import Foundation

struct GoogleTranslateDetectResult: Decodable {
    var data: GoogleData
    struct GoogleData: Decodable {
        var detections: [[Detection]]
        struct Detection: Decodable {
            var language: String
        }
    }
}
