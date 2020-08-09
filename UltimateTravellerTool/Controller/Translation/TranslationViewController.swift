//
//  TranslationViewController.swift
//  UltimateTravellerTool
//
//  Created by mickael ruzel on 08/08/2020.
//  Copyright © 2020 mickael ruzel. All rights reserved.
//

import UIKit

protocol passLanguageDelegate {
    func passLanguage(_ language: GoogleTranslateListResult.GoogleData.Languages, for buttonId: Int)
}

class TranslationViewController: UIViewController {
    
    // MARK: - Outlet
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet var languageButton: [SelectLaguagesButtons]!
    
    // MARK: - Properties
    
    var dataSource = [
        "c'est ok",
        "pourquoi pas",
        "vas te faire enculer!!"
    ]
    
    // MARK: - View Cycle Life
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView()

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
    private func keyboardWillShow(_ sender: NSNotification) {
        guard let keyboardSize = (sender.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }
        
        textField.frame.origin.y = 0 + keyboardSize.height
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
            destination.target = languageButton[0].language != nil ? languageButton[0].language?.language : nil
        }
    }
    
    // MARK: - Actions
    
    @IBAction func SelectLanguagesButtonTapped(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "SelectLanguageSegue", sender: sender.tag)
    }
    
}

extension TranslationViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        cell.textLabel?.text = dataSource[indexPath.row]
        return cell
    }
}

extension TranslationViewController: passLanguageDelegate {
    func passLanguage(_ language: GoogleTranslateListResult.GoogleData.Languages, for buttonId: Int) {
        for button in languageButton where button.tag == buttonId {
            button.language = language
        }
    }  
}
