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
    @IBOutlet weak var readButton: UIButton!
    @IBOutlet weak var destinationLanguageLabel: UILabel!
    
    weak var speechDelegate: ReadTextWithSpeechDelegate?
    var language: GoogleTranslateListResult.GoogleData.Languages? {
        didSet {
            destinationLanguageLabel.text = "Destination language : \(language?.name ?? "Unknown")"
        }
    }
    
    func setUp() {
        bubbleView.layer.cornerRadius = messageLabel.frame.height / 5
        bubbleView.backgroundColor = .systemGreen
        
        messageLabel.font = .systemFont(ofSize: 17, weight: .medium)
        messageLabel.numberOfLines = 0
        messageLabel.textColor = .white
    }
    
    @IBAction func readButtonTapped(_ sender: UIButton) {
        guard let destinationLanguage = language?.language, let message = messageLabel.text else {
            return
        }
        
        speechDelegate?.read(message, in: destinationLanguage)
    }
}
