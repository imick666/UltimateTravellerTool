//
//  UIViewController+Date.swift
//  UltimateTravellerTool
//
//  Created by mickael ruzel on 17/07/2020.
//  Copyright © 2020 mickael ruzel. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func dateFromTimeStamp(_ timeStamp: Int) -> Date {
        return Date(timeIntervalSince1970: Double(timeStamp))
    }
    
    func dateToDay(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .none
  
        if formatter.string(from: date) == formatter.string(from: Date()) {
            return "Today"
        } else {
            return formatter.string(from: date)
        }
    }
    
    func dateToHour(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        
        return formatter.string(from: date)
    }
    
    
}
