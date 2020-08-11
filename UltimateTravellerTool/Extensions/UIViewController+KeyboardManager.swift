//
//  UIViewController+KeyboardManager.swift
//  UltimateTravellerTool
//
//  Created by mickael ruzel on 10/08/2020.
//  Copyright © 2020 mickael ruzel. All rights reserved.
//

import UIKit

extension UIViewController {
    /**
        * Setting up observers to move view when keyboard appear
        */
       func setupKeyboardObservers() {
           NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)),
                                                  name: UIResponder.keyboardWillShowNotification, object: nil)
           NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)),
                                                  name: UIResponder.keyboardWillHideNotification, object: nil)
           NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)),
                                                  name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
       }

       /**
        * Manage view when keyboard appear
        */
       @objc
       private func keyboardWillChange(notification: NSNotification) {
           if let keyboardRect = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey]
               as? NSValue)?.cgRectValue {
               if notification.name == UIResponder.keyboardWillShowNotification ||
                   notification.name == UIResponder.keyboardWillChangeFrameNotification {
                   if let tabBarHeight = tabBarController?.tabBar.frame.height {
                       view.frame.origin.y = -(keyboardRect.height - tabBarHeight)
                   }
               } else {
                   view.frame.origin.y = 0
               }
           }
       }
}
