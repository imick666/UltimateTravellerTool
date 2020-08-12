//
//  OutgoingChatCell.swift
//  UltimateTravellerTool
//
//  Created by mickael ruzel on 10/08/2020.
//  Copyright © 2020 mickael ruzel. All rights reserved.
//

import UIKit

class IncommingChatCell: UITableViewCell {

    @IBOutlet weak var bubbleView: UIView!
    @IBOutlet weak var messageLabel: UILabel!
    
    func setUp() {
        bubbleView.layer.cornerRadius = messageLabel.frame.height / 5
        bubbleView.backgroundColor = .systemGreen
        
        messageLabel.font = .systemFont(ofSize: 17, weight: .medium)
        messageLabel.numberOfLines = 0
        messageLabel.textColor = .white
        
        self.isUserInteractionEnabled = false
    }
}
