//
//  IncommingChatCell.swift
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
        bubbleView.backgroundColor = .systemBlue
        
        messageLabel.font = .systemFont(ofSize: 17, weight: .medium)
        messageLabel.numberOfLines = 0
        messageLabel.textColor = .white
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
