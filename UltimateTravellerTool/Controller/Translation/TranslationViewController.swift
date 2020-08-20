//
//  TranslationViewController.swift
//  UltimateTravellerTool
//
//  Created by mickael ruzel on 08/08/2020.
//  Copyright © 2020 mickael ruzel. All rights reserved.
//

import UIKit
import AVFoundation

// MARK: - Protocol
protocol PassLanguageDelegate: class {
    /**
        Pass the selected language
        - parameter language: The language to pass
     */
    func passLanguage(_ language: GoogleTranslateListResult.GoogleData.Languages)
}

protocol ReadTextWithSpeechDelegate: class {
    func read(_ text: String, in language: String)
}

class TranslationViewController: UIViewController {
    
    // MARK: - Typealias

    typealias Language = GoogleTranslateListResult.GoogleData.Languages

    
    // MARK: - Outlet
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var languageButton: SelectLaguagesButtons!

    // MARK: - Properties
    
    let speechSynthesizer = AVSpeechSynthesizer()
    private let googleTranslate = GoogleTranslateService()
    var languagesList: [Language]?
    
    var dataSource = [TranslationMessages]() {
        didSet {
            tableView.reloadData()
            let lastIndexPath = IndexPath(row: dataSource.count - 1, section: 0)
            tableView.scrollToRow(at: lastIndexPath, at: .bottom, animated: true)
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
        
        textField.delegate = self
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
    
    /**
     Detect source linguage of a message, translate it to the target language, create the message bubble and add it to the message's array
     */
    private func detectLanguageAndTranslateText() {
        guard let destinationLanguage = languageButton.language?.language else {
            showAlert(title: "Error", message: "Please Select a language")
            return
        }
        
        guard let text = textField.text, !text.isEmpty else {
            showAlert(title: "Error", message: "Pease type a text to translate")
            textField.resignFirstResponder()
            return
        }
        
        textField.text = nil
        textField.resignFirstResponder()
        
        DetectSourceLanguage(message: text) { [unowned self] language in
            self.createMessage(message: text, isIncomming: false, sourceLanguage: language, destinationLanguage: nil)
            
            self.getTranslationTo(destinationLanguage, message: text) { (text) in
                guard let translatedText = text else {
                    self.createMessage(message: "Sorry I can't hellp you for the moment.../nPlease try again later...", isIncomming: true, sourceLanguage: nil, destinationLanguage: nil)
                    return
                }
                self.createMessage(message: translatedText, isIncomming: true, sourceLanguage: nil, destinationLanguage: self.languageButton.language)
            }
        }
    }
    
    /**
    Translate the text to the selected language
    - parameter language: The code of the target language (ex: "fr")
    - parameter message: The message to translate
    - parameter callback: A closure containing the translated language
     */
    private func getTranslationTo(_ language: String, message: String, callback: @escaping ((_ translatedText: String?) -> Void)) {
        let parameters = [("q", message), ("target", language)]
        googleTranslate.translateText(parameters: parameters) { result in
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
    
    /**
     Detect the language of a text
     - parameter message: The message to analyze
     - parameter callback: A closure containing the source language detected
     */
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
    
    /**
     Create a message to add to the messages array
     # Notes: #
     1. This methode add automacally a message to the message's array
     - parameter message: The text of the message
     - parameter isIncomming: A bool indicating if the message is incomming or outgoing
     - parameter sourceLanguage: The detected source language if message is outgoing, nil if message is incomming
     - parameter destinationLanguage: The target language if message is incomming, nil if message is outgoing
     */
    private func createMessage(message: String, isIncomming: Bool, sourceLanguage: Language?, destinationLanguage: Language?) {
        let message = TranslationMessages(message: message, isIncomming: isIncomming, date: Date(), sourceLanguage: sourceLanguage, destinationLanguage: destinationLanguage)
        dataSource.append(message)
    }
    
    /**
     Download the availible translation languages list
     # Notes: #
     1. This method store the list in "languagesList" property
     */
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
        detectLanguageAndTranslateText()
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
            incommingCell.speechDelegate = self
            incommingCell.language = dataSource[indexPath.row].destinationLanguage
            incommingCell.messageLabel.text = dataSource[indexPath.row].message
            return incommingCell
        } else {
            outgoingCell.setUp()
            outgoingCell.messageLabel.text = dataSource[indexPath.row].message
            let sourceLanguageName = dataSource[indexPath.row].sourceLanguage?.name
            outgoingCell.sourceLanguageLabel.text = "Source language detected : \(sourceLanguageName ?? "Unknown")"
            return outgoingCell
        }
    }
}

// MARK: - TextField Delegate

extension TranslationViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        detectLanguageAndTranslateText()
        return true
    }
}

// MARK: - PassLanguage Delegate

extension TranslationViewController: PassLanguageDelegate {
    func passLanguage(_ language: GoogleTranslateListResult.GoogleData.Languages) {
        languageButton.language = language
    }  
}

// MARK: - ReadTextWithSpeechDelegate

extension TranslationViewController: ReadTextWithSpeechDelegate {
    
    /**
     Read a messgae with AVSpeechSynthesizer
     - parameter text: The message to read
     - parameter language: The language of the message
     
     - warning: When this function is execute, if the synthesizer is speaking, it stop, else, it speak
     */
    func read(_ text: String, in language: String) {
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(language: language)
        utterance.rate = 0.5
        
        if speechSynthesizer.isSpeaking {
            speechSynthesizer.stopSpeaking(at: .immediate)
        } else {
            speechSynthesizer.speak(utterance)
        }
    }
    
    
}
