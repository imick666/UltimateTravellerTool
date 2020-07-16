//
//  UIViewController+Alert.swift
//  UltimateTravellerTool
//
//  Created by mickael ruzel on 16/07/2020.
//  Copyright © 2020 mickael ruzel. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func showAlert(title: String?, message: String?) {
        let activity = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        
        activity.addAction(ok)
        present(activity, animated: true, completion: nil)
    }
}
