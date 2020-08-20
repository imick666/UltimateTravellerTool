//
//  TranslateListApiFakeResponse.swift
//  UltimateTravellerToolTests
//
//  Created by mickael ruzel on 08/08/2020.
//  Copyright © 2020 mickael ruzel. All rights reserved.
//

import Foundation

class TranslateListApiFakeResponse {
    static let badResponse = HTTPURLResponse(url: URL(string: "google.fr")!, statusCode: 500, httpVersion: nil, headerFields: nil)
    static let goodResponse = HTTPURLResponse(url: URL(string: "google.fr")!, statusCode: 200, httpVersion: nil, headerFields: nil)
    
    class FakeError: Error { }
    static let fakeError = FakeError()
    
    private var goodData: Data? {
        let bundle = Bundle(for: TranslateListApiFakeResponse.self)
        let url = bundle.url(forResource: "TranslateListApiResult", withExtension: "json")
        return try? Data(contentsOf: url!)
    }
    
    private var badData: Data? {
        let string = "BadData"
        let data = string.data(using: .utf8)
        return data
    }
    
    static let incorrectData = TranslateListApiFakeResponse().badData
    static let correctData = TranslateListApiFakeResponse().goodData
}
