//
//  SelectLaguagesButtons.swift
//  UltimateTravellerTool
//
//  Created by mickael ruzel on 09/08/2020.
//  Copyright © 2020 mickael ruzel. All rights reserved.
//

import UIKit

class SelectLaguagesButtons: UIBarButtonItem {

    var language: GoogleTranslateListResult.GoogleData.Languages? {
        didSet {
            self.title = language?.name
        }
    }
}
