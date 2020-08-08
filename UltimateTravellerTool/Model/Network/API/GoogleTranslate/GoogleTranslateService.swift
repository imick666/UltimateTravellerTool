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
    
    init(client: HTTPClient = HTTPClient()) {
        self.client = client
    }
    
    func getLinguageList(body: [String: Any]?, callback: @escaping ((Result<GoogleTranslateListResult, NetworkError>) -> Void)) {
        guard let url = URL(string: baseUrl + "languages") else { return }
        
        client.requestJson(baseUrl: url, body: body, parameters: [("key", ApiConfig.googleTranslateApiKey)]) { (result: Result<GoogleTranslateListResult, NetworkError>) in
            callback(result)
        }
    }
    
    func translateText(body: [String: Any]?, callback: @escaping ((Result<GoogleTranslateResult, NetworkError>) -> Void)) {
        guard let url = URL(string: baseUrl) else { return }
        
        var bod = body
        bod?["format"] = "text"
        
        client.requestJson(baseUrl: url, body: bod, parameters: [("key", ApiConfig.googleTranslateApiKey)]) { (result: Result<GoogleTranslateResult, NetworkError>) in
            callback(result)
        }
    }
    
}
