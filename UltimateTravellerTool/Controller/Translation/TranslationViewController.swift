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
            let indexPath = IndexPath(row: dataSource.count - 1, section: 0)
            tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
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
    
    private func detectLanguageAndTranslateText(text: String) {
        guard let destinationLanguage = languageButton.language?.language else {
            showAlert(title: "Error", message: "Please Select a language")
            return
        }
        
        DetectSourceLanguage(message: text) { (language) in
            self.createMessage(message: text, isIncomming: false, sourceLanguage: language)
            
            self.getTranslationTo(destinationLanguage, message: text) { (text) in
                guard let translatedText = text else {
                    self.createMessage(message: "Sorry I can't hellp you for the moment.../nPlease try again later...", isIncomming: true, sourceLanguage: nil)
                    return
                }
                self.createMessage(message: translatedText, isIncomming: true, sourceLanguage: nil)
            }
        }
        
        
        
    }
    
    private func getTranslationTo(_ language: String, message: String, callback: @escaping ((_ translatedText: String?) -> Void)) {
        let parameters = [("q", message), ("target", language)]
        googleTranslate.translateText(parameters: parameters) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .failure(_):
                    callback(nil)
                case .success(let data):
                    let translation = data.data.translations[0].translatedText
                    callback(translation)
                }
            }
        }
    }
    
    private func DetectSourceLanguage(message: String, callback: @escaping ((_ sourceLanguage: Language?) -> Void)) {
        googleTranslate.detectLanguage(query: [("q", message)]) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .failure(_):
                    callback(nil)
                case .success(let data):
                    let sourceLanguageCode = data.data.detections[0][0].language
                    var sourceLanguage: Language? {
                        return self.languagesList?.first(where: { $0.language == sourceLanguageCode })
                    }
                    callback(sourceLanguage)
                }
            }
        }
    }
    
    private func createMessage(message: String, isIncomming: Bool, sourceLanguage: Language?) {
        let message = TranslationMessages(message: message, isIncomming: isIncomming, date: Date(), sourceLanguage: sourceLanguage)
        dataSource.append(message)
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
        guard let list = languagesList else {
            showAlert(title: "Error", message: "Languages list couldn't be loaded, Please try later")
            return
        }
        
        let alert = UIAlertController(title: "Select destination Language", message: nil, preferredStyle: .actionSheet)
        
        let storyoard = UIStoryboard(name: "Main", bundle: .main)
        let vc = storyoard.instantiateViewController(withIdentifier: "SelectLanguageSbId") as! SelectLanguageTableViewController
        vc.delegate = self
        vc.sortLangueInSection(list)
        vc.alertController = alert
        vc.preferredContentSize.height = 300
        
        let fullScreen = UIAlertAction(title: "Show in fullscreen", style: .default) { (action) in
            self.performSegue(withIdentifier: "SelectLanguageSegue", sender: nil)
        }
        let cancel = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
        
        alert.addAction(fullScreen)
        alert.setValue(vc, forKeyPath: "contentViewController")
        alert.addAction(cancel)
        
        present(alert, animated: true, completion: nil)
        
        
    }
    
    @IBAction func sendMessageButtonTapped(_ sender: Any) {
        guard let messageText = textField.text, !messageText.isEmpty else {
            showAlert(title: "Error", message: "Pease type a text to translate")
            textField.resignFirstResponder()
            return
        }
        detectLanguageAndTranslateText(text: messageText)
        textField.text = nil
        textField.resignFirstResponder()
    }
}

// MARK: - TableView

extension TranslationViewController: UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - Table view data source
    
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
            let sourceLanguageName = dataSource[indexPath.row].sourceLanguage?.name
            outgoingCell.sourceLanguageLabel.text = "Language detected : \(sourceLanguageName ?? "Unknown")"
            return outgoingCell
        }
    }
}

extension TranslationViewController: passLanguageDelegate {
    func passLanguage(_ language: GoogleTranslateListResult.GoogleData.Languages) {
        languageButton.language = language
    }  
}
