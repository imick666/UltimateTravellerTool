//
//  TranslationViewController.swift
//  UltimateTravellerTool
//
//  Created by mickael ruzel on 08/08/2020.
//  Copyright © 2020 mickael ruzel. All rights reserved.
//

import UIKit

protocol passLanguageDelegate {
    func passLanguage(_ language: GoogleTranslateListResult.GoogleData.Languages)
}

class TranslationViewController: UIViewController {
    
    // MARK: - Outlet
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var languageButton: SelectLaguagesButtons!
    
    // MARK: - Typealias

    typealias Language = GoogleTranslateListResult.GoogleData.Languages
    
    // MARK: - Properties
    
    private let googleTranslate = GoogleTranslateService()
    var languagesList: [Language]?
    
    var dataSource = [TranslationMessages]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    // MARK: - View Cycle Life
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getLanguagesList()
        
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        
        setupKeyboardObservers()
                
        let tap = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard(_:)))
        view.addGestureRecognizer(tap)
        
        if languageButton.language == nil {
            languageButton.title = "Select a language"
        } else {
            languageButton.title = languageButton.language?.name
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = false
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
                    let translate = TranslationMessages(message: translation.translatedText, isIncomming: true)
                    self.dataSource.append(translate)
                }
            }
        }
    }
    
    private func getLanguagesList() {
        googleTranslate.getLinguageList { (result) in
            DispatchQueue.main.async {
                switch result {
                case .failure(let error):
                    self.showAlert(title: "Error", message: error.description)
                case .success(let data):
                    self.languagesList = data.data.languages
                }
            }
        }
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SelectLanguageSegue" {
            guard let destination = segue.destination as? SelectLanguageTableViewController else { return }
            guard let list = languagesList else {
                showAlert(title: "Error", message: "Languages list couldn't be loaded, Please try later")
                return
            }
            destination.sortLangueInSection(list)
            destination.delegate = self
        }
    }
    
    // MARK: - Actions
    
    @IBAction func SelectLanguagesButtonTapped(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "SelectLanguageSegue", sender: nil)
    }
    
    @IBAction func sendMessageButtonTapped(_ sender: Any) {
        guard let selectedLanguage = languageButton.language else {
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
        getTranslationTo(selectedLanguage.language, message: messageText)
        let myMessage = TranslationMessages(message: messageText, isIncomming: false)
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
        guard let incommingCell = tableView.dequeueReusableCell(withIdentifier: "IncommingChatCell", for: indexPath) as? IncommingChatCell,
            let outgoingCell = tableView.dequeueReusableCell(withIdentifier: "OutgoingChatCell", for: indexPath) as? OutgoingChatCell else {
                return UITableViewCell()
        }
        
        if dataSource[indexPath.row].isIncomming {
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
    func passLanguage(_ language: GoogleTranslateListResult.GoogleData.Languages) {
        languageButton.language = language
    }  
}
