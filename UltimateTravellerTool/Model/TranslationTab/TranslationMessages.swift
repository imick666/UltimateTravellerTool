//
//  TranslationMessages.swift
//  UltimateTravellerTool
//
//  Created by mickael ruzel on 12/08/2020.
//  Copyright © 2020 mickael ruzel. All rights reserved.
//

import Foundation

struct TranslationMessages {
    var message: String
    var isIncomming: Bool
    var date: Date
    var sourceLanguage: GoogleTranslateListResult.GoogleData.Languages?
    var destinationLanguage: GoogleTranslateListResult.GoogleData.Languages?
}
