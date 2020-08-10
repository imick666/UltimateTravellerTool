//
//  TranslationViewController.swift
//  UltimateTravellerTool
//
//  Created by mickael ruzel on 08/08/2020.
//  Copyright © 2020 mickael ruzel. All rights reserved.
//

import UIKit

struct Message {
    var message: String
    var incomming: Bool
}

protocol passLanguageDelegate {
    func passLanguage(_ language: GoogleTranslateListResult.GoogleData.Languages, for buttonId: Int)
}

class TranslationViewController: UIViewController {
    
    // MARK: - Outlet
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var sendMessageView: UIView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet var languageButton: [SelectLaguagesButtons]!

    // MARK: - Properties
    
    var dataSource = [
        Message(message: "Hello, My name is john and I am very happy to chat with you! I hope this message will use more than one line", incomming: true),
        Message(message: "Hello john! Nice to chat with you, my name is tony and I am the biggest cocaïne's reseller around all the world!!", incomming: false),
        Message(message: "this is a little string", incomming: true),
        Message(message: "Coucou mon amour, je t'aime très très fort de toute m came!!!!", incomming: false)
    ]
    
    // MARK: - View Cycle Life
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard(_:)))
        view.addGestureRecognizer(tap)
        
        for button in languageButton {
            if button.language == nil {
                button.title = "Select a language"
            }
        }
    }
    
    // MARK: - OBJC Selectors
    
    @objc
    private func keyboardWillShow(_ notification: NSNotification) {
        
    }
    
    @objc
    private func hideKeyboard(_ sender: UITapGestureRecognizer) {
        textField.resignFirstResponder()
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SelectLanguageSegue" {
            guard let destination = segue.destination as? SelectLanguageTableViewController else { return }
            destination.buttonId = sender as? Int
            destination.delegate = self
        }
    }
    
    // MARK: - Actions
    
    @IBAction func SelectLanguagesButtonTapped(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "SelectLanguageSegue", sender: sender.tag)
    }
    
    @IBAction func sendMessageButtonTapped(_ sender: Any) {
    }
}

extension TranslationViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let outgoingCell = tableView.dequeueReusableCell(withIdentifier: "OutgoingChatCell", for: indexPath) as? OutgoingChatCell else {
            return UITableViewCell()
        }
        guard let incommingCell = tableView.dequeueReusableCell(withIdentifier: "IncommingChatCell", for: indexPath) as? IncommingChatCell else {
            return UITableViewCell()
        }
        
        if !dataSource[indexPath.row].incomming {
            outgoingCell.setUp()
            outgoingCell.messageLabel.text = dataSource[indexPath.row].message
            return outgoingCell
        } else {
            incommingCell.setUp()
            incommingCell.messageLabel.text = dataSource[indexPath.row].message
            return incommingCell
        }
    }
}

extension TranslationViewController: passLanguageDelegate {
    func passLanguage(_ language: GoogleTranslateListResult.GoogleData.Languages, for buttonId: Int) {
        for button in languageButton where button.tag == buttonId {
            button.language = language
        }
    }  
}
