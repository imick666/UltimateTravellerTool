//
//  Alert.swift
//  UltimateTravellerTool
//
//  Created by mickael ruzel on 05/07/2020.
//  Copyright © 2020 mickael ruzel. All rights reserved.
//

import UIKit

class Alert: UIActivity {

    func showAlert(title: String?, message: String?, controller: UIViewController) {
        let activity = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        
        activity.addAction(ok)
        controller.present(activity, animated: true, completion: nil)
    }
    
}
