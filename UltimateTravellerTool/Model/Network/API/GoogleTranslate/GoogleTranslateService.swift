//
//  GoogleTranslateService.swift
//  UltimateTravellerTool
//
//  Created by mickael ruzel on 08/08/2020.
//  Copyright © 2020 mickael ruzel. All rights reserved.
//

import Foundation

final class GoogleTranslateService {
    
    // MARK: - Properties
    
    let baseUrl = "https://translation.googleapis.com/language/translate/v2/"
    let client: HTTPClient
    let localeLanguage = Locale.current.languageCode ?? "en"
    
    // MARK: - Init
    
    init(client: HTTPClient = HTTPClient()) {
        self.client = client
    }
    
    // MARK: - Methodes
    
    /**
    Get availible language for translation
    - parameter callback: A closure containning availible language
    */
    func getLinguageList(callback: @escaping ((Result<GoogleTranslateListResult, NetworkError>) -> Void)) {
        guard let url = URL(string: baseUrl + "languages") else { return }
        
        client.requestJson(baseUrl: url, parameters: [("key", ApiConfig.googleTranslateApiKey), ("target", localeLanguage)]) { (result: Result<GoogleTranslateListResult, NetworkError>) in
            callback(result)
        }
    }
    
    /**
     Translate a text in
     - parameter parameters: The text to translate (with key: "q" and the language destination (with key: "target")
     - parameter callback: A closure containning the translated text
     */
    func translateText(parameters: [(String, Any)]?, callback: @escaping ((Result<GoogleTranslateResult, NetworkError>) -> Void)) {
        guard let url = URL(string: baseUrl) else { return }
        
        var param = parameters
        param?.append(("format", "text"))
        param?.append(("key", ApiConfig.googleTranslateApiKey))
        
        client.requestJson(baseUrl: url, parameters: param) { (result: Result<GoogleTranslateResult, NetworkError>) in
            callback(result)
        }
    }
    
    /**
     Detect the language of a text
     - parameter parameters: The text for detection (with key: "q")
     - parameter callback: A closure containning the detected language
     */
    func detectLanguage(query: [(String, Any)], callback: @escaping ((Result<GoogleTranslateDetectResult, NetworkError>) -> Void)) {
        guard let url = URL(string: baseUrl + "detect") else { return }
        
        var parameters = query
        parameters.append(("key", ApiConfig.googleTranslateApiKey))
        
        client.requestJson(baseUrl: url, parameters: parameters) { (result: Result<GoogleTranslateDetectResult, NetworkError>) in
            callback(result)
        }
        
    }
    
}
