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
    
    func timeStampToDay(_ timeStamp: Int) -> String {
        let date = dateFromTimeStamp(timeStamp)
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        return formatter.string(from: date)
    }
    
    func timeStampToHour(_ timestamp: Int) -> String {
        let date = dateFromTimeStamp(timestamp)
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        
        return formatter.string(from: date)
    }
}
