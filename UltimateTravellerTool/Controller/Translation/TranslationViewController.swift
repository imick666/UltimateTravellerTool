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
    var incomming: Bool = true
}

protocol passLanguageDelegate {
    func passLanguage(_ language: GoogleTranslateListResult.GoogleData.Languages, for buttonId: Int)
}

class TranslationViewController: UIViewController {
    
    // MARK: - Outlet
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet var languageButton: [SelectLaguagesButtons]!

    // MARK: - Properties
    
    let googleTranslate = GoogleTranslateService()
    
    var dataSource = [
        Message(message: "Hello, My name is john and I am very happy to chat with you! I hope this message will use more than one line"),
        Message(message: "Hello john! Nice to chat with you, my name is tony and I am the biggest cocaïne's reseller around all the world!!", incomming: false),
        Message(message: "this is a little string"),
        Message(message: "Coucou mon amour, je t'aime très très fort de toute m came!!!!", incomming: false)
        ] {
        didSet {
            tableView.reloadData()
        }
    }
    
    // MARK: - View Cycle Life
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        
        setupKeyboardObservers()
                
        let tap = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard(_:)))
        view.addGestureRecognizer(tap)
        
        if languageButton[0].language == nil {
            languageButton[0].title = "Wait for detection..."
        } else {
            languageButton[0].title = languageButton[0].language?.name
        }
        
        if languageButton[1].language == nil {
            languageButton[1].title = "Select a language"
        } else {
            languageButton[1].title = languageButton[0].language?.name
        }
    }
    
    // MARK: - OBJC Selectors
    
    @objc
    private func hideKeyboard(_ sender: UITapGestureRecognizer) {
        textField.resignFirstResponder()
    }
    
    // MARK: - Methodes
    
    private func getTranslationTo(_ language: String, message: String) {
        let parameters = [("q", message), ("target", language)]
        googleTranslate.translateText(parameters: parameters) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .failure(let error):
                    self.showAlert(title: "Error", message: error.description)
                case .success(let data):
                    let translation = data.data.translations[0]
                    let translate = Message(message: translation.translatedText)
                    self.dataSource.append(translate)
                }
            }
        }
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
        guard languageButton[1].language != nil else {
            showAlert(title: "Error", message: "Please select a language")
            textField.resignFirstResponder()
            textField.text = nil
            return
        }
        guard let messageText = textField.text else { return }

        guard !messageText.isEmpty else {
            showAlert(title: "Error", message: "Pease type a text to translate")
            textField.resignFirstResponder()
            return
        }
        getTranslationTo(languageButton[1].language?.language ?? "en", message: messageText)
        let myMessage = Message(message: messageText, incomming: false)
        dataSource.append(myMessage)
        textField.text = nil
        textField.resignFirstResponder()
    }
}

extension TranslationViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let incommingCell = tableView.dequeueReusableCell(withIdentifier: "IncommingChatCell", for: indexPath) as? IncommingChatCell else {
            return UITableViewCell()
        }
        guard let outgoingCell = tableView.dequeueReusableCell(withIdentifier: "OutgoingChatCell", for: indexPath) as? OutgoingChatCell else {
            return UITableViewCell()
        }
        
        if dataSource[indexPath.row].incomming {
            incommingCell.setUp()
            incommingCell.messageLabel.text = dataSource[indexPath.row].message
            return incommingCell
        } else {
            outgoingCell.setUp()
            outgoingCell.messageLabel.text = dataSource[indexPath.row].message
            return outgoingCell
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
