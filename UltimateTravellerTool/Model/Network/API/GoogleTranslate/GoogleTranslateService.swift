//
//  GoogleTranslateService.swift
//  UltimateTravellerTool
//
//  Created by mickael ruzel on 08/08/2020.
//  Copyright © 2020 mickael ruzel. All rights reserved.
//

import Foundation

final class GoogleTranslateService {
    
    let baseUrl = "https://translation.googleapis.com/language/translate/v2/"
    let client: HTTPClient
    let localeLanguage = Locale.current.languageCode ?? "en"
    
    init(client: HTTPClient = HTTPClient()) {
        self.client = client
    }
    
    func getLinguageList(callback: @escaping ((Result<GoogleTranslateListResult, NetworkError>) -> Void)) {
        guard let url = URL(string: baseUrl + "languages") else { return }
        
        client.requestJson(baseUrl: url, parameters: [("key", ApiConfig.googleTranslateApiKey), ("target", localeLanguage)]) { (result: Result<GoogleTranslateListResult, NetworkError>) in
            callback(result)
        }
    }
    
    func translateText(parameters: [(String, Any)]?, callback: @escaping ((Result<GoogleTranslateResult, NetworkError>) -> Void)) {
        guard let url = URL(string: baseUrl) else { return }
        
        var param = parameters
        param?.append(("format", "text"))
        param?.append(("key", ApiConfig.googleTranslateApiKey))
        
        client.requestJson(baseUrl: url, parameters: param) { (result: Result<GoogleTranslateResult, NetworkError>) in
            callback(result)
        }
    }
    
}
